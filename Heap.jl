module Heap

# implementation of heap (just for fun)
# hacked out of https://github.com/JuliaCollections/DataStructures.jl

export heappush!, heappop!

heapleft(i::Integer) = 2i
heapright(i::Integer) = 2i + 1
heapparent(i::Integer) = div(i, 2)

@inline function heappush!(heap::AbstractArray{T}, x::T, f::Function = <) where {T}
    push!(heap, x)
    # pull the tail of the heap through it to restore the heap property
    position = length(heap)
    @inbounds while (new_position = heapparent(position)) >= 1
        f(x, heap[new_position]) || break
        heap[position] = heap[new_position]
        position = new_position
    end
    heap[position] = x
    return heap
end

function heappop!(heap::AbstractArray, f::Function = <)
    p = popfirst!(heap)
    N = length(heap)
    if N > 0
        let x = heap[end]
            # circshift heap forward by one
            for i = N:-1:2
                heap[i] = heap[i-1]
            end
            # push the tail of the heap through it to restore the heap property
            position = 1
            @inbounds while (left = heapleft(position)) <= N
                right = heapright(position)
                new_position = right > N || f(heap[left], heap[right]) ? left : right
                f(heap[new_position], x) || break
                heap[position] = heap[new_position]
                position = new_position
            end
            heap[position] = x
        end
    end
    return p
end
end
