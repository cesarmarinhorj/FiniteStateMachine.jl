function showMe(n)
    println(n)
    n
end

function initFSM()
    fsm = state_machine(Dict{Symbol, Any}(
        :initial => :first,
        :final => :fourth,
        :events => ( [ Dict{Symbol, FSMDictValue}(
                :name => :hop,
                :from => :first,
                :to => :second
            ),  Dict{Symbol, FSMDictValue}(
                :name => :skip,
                :from => [:first, :second],
                :to => :third
            ),  Dict{Symbol, FSMDictValue}(
                :name => :jump,
                :from => :third,
                :to => :fourth
            )
        ]),
        :callbacks => Dict{Symbol, Any}(
            :onleavestate => (fsm::StateMachine, args...) -> showMe(:a),
            :onenterstate => (fsm::StateMachine, args...) -> showMe(:b),
            :onchangestate => (fsm::StateMachine, args...) -> showMe(:c),

            :onbeforeevent => (fsm::StateMachine, args...) -> showMe(:d),
            :onafterevent => (fsm::StateMachine, args...) -> showMe(:e),

            :onleavefirst => (fsm::StateMachine, args...) -> showMe(:f),
            :onentersecond => (fsm::StateMachine, args...) -> showMe(:g),

            :onbeforejump => (fsm::StateMachine, args...) -> showMe(:h),
            :onafterskip => (fsm::StateMachine, args...) -> showMe(:i),
        )
    ))
end

function testInverse(fsm)
    println(fire(fsm, :can, :jump) ? (fire(fsm, :jump); "jump...") : "No Jump here...")
    println(fire(fsm, :can, :skip) ? (fire(fsm, :skip); "skip...") : "No skip here...")
    println(fire(fsm, :can, :hop) ? (fire(fsm, :hop); "hop..") : "No hop here...")
    println("State: ", fsm.current, ", ", (fire(fsm, :finished) ? "is" : "not"), " finished...")
end


function testRandom(fsm)
    if fire(fsm, :finished)
        println("State: ", fsm.current, ",  finished !")
    else
        println("State: ", fsm.current, ",  not finished yet..")
        
        step = rand(filter(m -> m != :startup, keys(fsm.map)))
        
        if fire(fsm, :can, step)
            fire(fsm, step)
            println( string(step,".."))
        else
            println("No ",step, " here...")
        end
        println("State: ", fsm.current, ", ", (fire(fsm, :finished) ? "is" : "not"), " finished...")
    end
end

function testRandomLoop()
    fsm = initFSM()
    while !fire(fsm, :finished)
        testRandom(fsm)
    end
end

function goTestMe(visitor, fsm)
    fsm = initFSM()
   
    println("Start loop...")
    while !fire(fsm, :finished)
        testInverse(fsm)
    end

    println("finished...")
    testInverse(fsm)
end

@testset "fsm tests" begin
    testRandomLoop()
end
