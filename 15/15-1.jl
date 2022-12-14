using Test

Y = 10

dist(a,b) = sum(abs.(a - b))

function points(sensor, beacon)
    # valid = Set()
    (sx,sy) = sensor
    # (bx,by) = beacon
    (dx,dy) = abs.(sensor - beacon)
    d = dx+dy

    # Filter sensors, only look at the ones intersecting Y
    if abs(sy-Y) > d
        # println("Line does not intersect")
        return []
    end

    # Y is constant, so key is only x component
    yDiff = abs(Y-sy)
    xD = d - yDiff

    # println((sx, xD))
    # collect(sx-xD:sx+xD)

    Set([x for x in sx-xD:sx+xD if abs(x-sx) <= xD])


    # off = max(dx,dy)

    # for x in sx-off:sx+off # need to reduce this
    #     if dist([sx, sy], [x,Y]) > d
    #         # println(d)
    #         continue
    #     end
    #     push!(valid, [x,Y])
    # end
    # valid
end

function work(filepath::String)
    f = open(filepath)

    sensor2beacon = Dict()
    for l in eachline(f)
        matches = map(x->parse(Int64, x), [m[1] for m in eachmatch(r"(-?\d+)", l)])
        (sx,sy,bx,by) = matches
        sensor2beacon[[sx,sy]] = [bx, by]
        # println(matches)
    end

    close(f)

    sensors = collect(keys(sensor2beacon))

    cannot = Set()
    for sensor in sensors
        # println(sensor)
        nearest = sensor2beacon[sensor]
        # println((sensor, nearest))
        distance = dist(sensor, nearest)
        println((sensor, nearest, distance))
        
        # distance = abs(sensor[1] - nearest[1]) + abs(sensor[2] - nearest[2])
        # (sx,sy) = sensor
        ps = points(sensor, nearest)
        print("Unioning...")
        union!(cannot, ps)
        println("Done!")
        
    end

   
    beacons = Set([v[1] for v in values(sensor2beacon) if v[2] == Y])
    setdiff!(cannot, beacons)

    # println((sensors, beacons))
    # println(sort(collect(cannot)))
    length(cannot)
end
result = work("15/sample.txt")
Y=2000000
result = work("15/input.txt")
println("Result: ", result)
@test result == 26
