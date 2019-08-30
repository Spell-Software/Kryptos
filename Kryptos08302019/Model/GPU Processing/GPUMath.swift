//
//  GPUMath.swift
//  Kryptos
//
//  Created by Craig Spell on 8/24/19.
//  Copyright © 2019 Spell Software Inc. All rights reserved.
//

import Foundation
import Metal

enum Direction {
    case addition
    case subtraction
}
struct GPUInterface {

    var mainComputeDevice : MTLDevice!
    let availableComputeDevices = MTLCopyAllDevices()
    let computeLibrary : MTLLibrary!
    let commandQueue : MTLCommandQueue

    let addfunction : MTLFunction?
    let subFunction : MTLFunction?

    init() {
        mainComputeDevice = MTLCreateSystemDefaultDevice()

        for device in availableComputeDevices {
            if device.isRemovable {
                mainComputeDevice = device
            }
        }

        computeLibrary = mainComputeDevice.makeDefaultLibrary()
        commandQueue = mainComputeDevice.makeCommandQueue()!


        addfunction = computeLibrary.makeFunction(name: "add_arrays")
        subFunction = computeLibrary.makeFunction(name: "subtract_arrays")

        #if DEBUG
        assert(computeLibrary != nil)
        #endif
    }
}

struct GPUMath {

    static private let gpu = GPUInterface()
    private var arraySize : Int = 0

    private var array1 : [Int]
    private var array2 : [Int]
    private var alphabetSize : Int

    init(array1: [Int], array2: [Int], alphabetSize: Int){

        self.array1 = array1
        self.array2 = array2
        self.alphabetSize = alphabetSize

        if array2.count != array1.count {
            print("Error array sizes are different: size of array in GPUSetup will be reduced")
        }

        arraySize = min(array1.count, array2.count)
    }

    private func encode(encoder: MTLComputeCommandEncoder, resultBuffer: MTLBuffer, for direction: Direction) {

        let bufferSize = arraySize * MemoryLayout<CInt>.stride

        assert(bufferSize <= GPUMath.gpu.mainComputeDevice.maxBufferLength)

        let bufferA = GPUMath.gpu.mainComputeDevice.makeBuffer(bytes: Array(array1.suffix(arraySize).map({return CInt($0)})),
                                                               length: bufferSize,
                                                               options: .storageModeShared)

        let bufferB = GPUMath.gpu.mainComputeDevice.makeBuffer(bytes: Array(array2.suffix(arraySize).map({return CInt($0)})),
                                                               length: bufferSize,
                                                               options: .storageModeShared)

        var size = CInt(alphabetSize)
        let bufferL = GPUMath.gpu.mainComputeDevice.makeBuffer(bytes: &size,
                                                               length: MemoryLayout<CInt>.size,
                                                               options: .storageModeShared)

        let function = direction == Direction.addition ? GPUMath.gpu.addfunction! : GPUMath.gpu.subFunction!

        do{
            let pso = try GPUMath.gpu.mainComputeDevice.makeComputePipelineState(function: function)

            encoder.setComputePipelineState(pso)

            encoder.setBuffer(bufferA, offset: 0, index: 0)
            encoder.setBuffer(bufferB, offset: 0, index: 1)
            encoder.setBuffer(bufferL, offset: 0, index: 2)
            encoder.setBuffer(resultBuffer, offset: 0, index: 3)


            let gridSize = MTLSizeMake(arraySize, 1, 1)
            let threadGroupSize = min(pso.maxTotalThreadsPerThreadgroup, arraySize)
            let groupSize = MTLSizeMake(threadGroupSize, 1, 1)

            encoder.dispatchThreads(gridSize, threadsPerThreadgroup: groupSize)

        } catch let error {
            print(error)
            print("failed to add function to pipeline")
            return
        }
    }

    private func perform(direction: Direction, completion: @escaping (_ results:[Int], _ success: Bool) -> Void) {

        if let commandBuffer = GPUMath.gpu.commandQueue.makeCommandBuffer(){

            if let computeEncoder = commandBuffer.makeComputeCommandEncoder(dispatchType: .concurrent) {

                let bufferSize = arraySize * MemoryLayout<CInt>.stride
                let resultBuffer = GPUMath.gpu.mainComputeDevice.makeBuffer(length: bufferSize,
                                                                            options: .storageModeManaged)!

                self.encode(encoder: computeEncoder, resultBuffer: resultBuffer, for: direction)

                commandBuffer.addCompletedHandler { (cmdBuffer) in

                    var result = [Int]()

                    for i in 0..<self.arraySize {

                        let offset = i * MemoryLayout<CInt>.size
                        result.append( Int(resultBuffer.contents().load(fromByteOffset: offset, as: CInt.self)) )
                    }
                    completion( result, cmdBuffer.error == nil)
                }

                computeEncoder.endEncoding()
                commandBuffer.commit()
            }
        }
    }

    func add( completion: @escaping (_ results:[Int], _ success: Bool) -> Void) {
        perform(direction: .addition, completion: completion)
    }

    func subtract(completion: @escaping (_ results:[Int], _ success: Bool) -> Void) {
        perform(direction: .subtraction, completion: completion)
    }
}
