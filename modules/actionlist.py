def to_dicts(action_list):
    """
    convert a list of actions to a list of action_dicts
    this is more consistent with the structure that flatland accepts
    """
    result = []

    current_time_step = action_list[0][2]
    current_dict = {}

    for agent, command, time_step in action_list:
        if time_step != current_time_step:
            result.append(current_dict)
            current_dict = {}
            current_time_step = time_step
        
        current_dict[agent] = command

    # Append the last dictionary after the loop
    result.append(current_dict)

    print(result)


def build_action_list(models):
    """
    given a model from clingo, build an python action list
    """
    action_list = []
    for func in models[0]: # only the first model
        prefix = func.name[:6]
        if prefix == "action":
            action = func.arguments[1].name
            agent, timestep = func.arguments[0], func.arguments[2]
            agent_num = agent.arguments[0].number
            action_list.append((agent_num,action,timestep.number))

    sorted_list = sorted(action_list, key=lambda x: (x[2], x[0]))
    return(to_dicts(sorted_list))