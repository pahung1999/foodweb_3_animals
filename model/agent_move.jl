function agent_move!(agent::Animal, model)
	species = agent.species
    move_animal!(agent,model, Val(agent.species))

end

include("./sub_function.jl")



function move_animal!(agent,model, ::Val{:tiger})
	radius=2
	positions = collect(nearby_positions(agent,model, radius))
	best_pos_list = []
	max_point = 0
	for pos in positions
		pos_point = 0
		#Không hổ
		if count(agent -> agent.species==:tiger ,agents_in_position(pos,model)) < 1
			if agent.energy <= 0.25
				pos_point +=1
			else
				pos_point +=10
			end
		end
		#Nhiều lợn
		num_boar_in_pos = count(agent -> agent.species==:boar ,agents_in_position(pos,model))
		if num_boar_in_pos > 0
			if agent.energy < 0.25
				pos_point +=10
			else
				pos_point +=1
			end
		end
		# print("pos_point: ",pos_point, "\n")
		if pos_point > max_point
			best_pos_list = []
			push!(best_pos_list, pos)
			max_point = pos_point
		elseif  pos_point == max_point
			push!(best_pos_list, pos)
		end
	end
	return move_agent!(agent, rand(model.rng,best_pos_list), model)
end

	

function move_animal!(agent, model, ::Val{:leopard})
	# Nearby position
	radius = 2
	positions = collect(nearby_positions(agent,model, radius))

	best_pos_list = []
	max_point = 0
	for pos in positions
		pos_point = 0
		#Không hổ
		if count(agent -> agent.species==:tiger ,agents_in_position(pos,model)) < 1
			if agent.energy <= 0.25
				pos_point +=10
			else
				pos_point +=100
			end
		end
		#Ít báo
		if count(agent -> agent.species==:leopard ,agents_in_position(pos,model)) < 3
			if agent.energy <= 0.25
				pos_point +=1
			else
				pos_point +=10
			end
		end
		#Có lợn
		if count(agent -> agent.species==:boar ,agents_in_position(pos,model)) > 0
			if agent.energy <= 0.25
				pos_point +=100
			else
				pos_point +=1
			end
		end
		# print("pos_point: ",pos_point, "\n")
		if pos_point > max_point
			best_pos_list = []
			push!(best_pos_list, pos)
			max_point = pos_point
		elseif  pos_point == max_point
			push!(best_pos_list, pos)
		end
	end
	return move_agent!(agent, rand(model.rng,best_pos_list), model)
end


function move_animal!(agent, model, ::Val{:boar})
	# Nearby position
	radius = 1
	positions = collect(nearby_positions(agent,model, radius))

	best_pos_list = []
	max_point = 0
	for pos in positions
		pos_point = 0
		#Không hổ, báo
		if count(agent -> agent.species==:tiger ,agents_in_position(pos,model)) < 1 || count(agent -> agent.species==:leopard ,agents_in_position(pos,model)) < 1
			if agent.energy <= 0.25
				pos_point +=1
			else
				pos_point +=10
			end
		end
		#Ít lợn
		num_boar_in_pos = count(agent -> agent.species==:boar ,agents_in_position(pos,model))
		if num_boar_in_pos < 5
			if agent.energy < 0.25
				pos_point +=1
			else
				pos_point +=10
			end
		end
		#Có thức ăn
		food_energy = model.food[pos...]
		if agent.energy < 0.25
			pos_point += food_energy * 10
		else
			pos_point += 1
		end
		# print("pos_point: ",pos_point, "\n")
		if pos_point > max_point
			best_pos_list = []
			push!(best_pos_list, pos)
			max_point = pos_point
		elseif  pos_point == max_point
			push!(best_pos_list, pos)
		end
	end
	return move_agent!(agent, rand(model.rng,best_pos_list), model)
end
