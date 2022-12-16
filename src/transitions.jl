# Transition callback
function callback(fsm::StateMachine, action, name::Symbol, from::Symbol, to::Symbol)
    if haskey(fsm.actions, action)
        fsm.actions[action](fsm, name, from, to)
    end
end

# Before event
function before_event(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol)
    before_this_event(fsm, name, from, to)
    before_any_event(fsm, name, from, to)
end

before_this_event(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol) = callback(fsm, string(String(:onbefore), name), name, from, to)

before_any_event(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol) = callback(fsm, :onbeforeevent, name, from, to)

# After event
function after_event(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol)
    after_this_event(fsm, name, from, to)
    after_any_event(fsm, name, from, to)
end

after_this_event(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol) = callback(fsm, string(String(:onafter), String(name)), name, from, to)

function after_any_event(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol)
    if haskey(fsm.actions, :onafterevent)
        action = :onafterevent
    elseif haskey(fsm.actions, :onevent)
        action = :onevent
    else
        return
    end
    callback(fsm, action, name, from, to)
end

# Change of state
change_state(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol) = callback(fsm, :onchangestate, name, from, to)

# Entering a state
function enter_state(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol)
    enter_this_state(fsm, name, from, to)
    enter_any_state(fsm, name, from, to)
end

enter_this_state(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol) = callback(fsm, string(String(:onenter), String(to)), name, from, to)

function enter_any_state(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol)
    if haskey(fsm.actions, :onenterstate)
        action = :onenterstate
    elseif haskey(fsm.actions, :onstate)
        action = :onstate
    else
        return
    end
    callback(fsm, action, name, from, to)
end

# Leaving a state
function leave_state(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol)
    leave_this_state(fsm, name, from, to)
    leave_any_state(fsm, name, from, to)
end

leave_this_state(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol) = callback(fsm, string(String(:onleave), String(from)), name, from, to)

leave_any_state(fsm::StateMachine, name::Symbol, from::Symbol, to::Symbol) = callback(fsm, :onleavestate, name, from, to)
