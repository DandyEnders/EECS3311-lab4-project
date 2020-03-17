note
	description: "Input Handler"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_INPUT_HANDLER_INTERFACE
inherit
	ETF_TYPE_CONSTRAINTS

feature {NONE}

	make_without_running(etf_input: STRING; a_commands: ETF_ABSTRACT_UI_INTERFACE)
			-- convert an input string into array of commands
	  	do
	  		create on_error
		  	input_string := etf_input
		  	abstract_ui  := a_commands
	  	end

	make(etf_input: STRING; a_commands: ETF_ABSTRACT_UI_INTERFACE)
			-- convert an input string into array of commands
	  	do
	  		make_without_running(etf_input, a_commands)
			parse_and_validate_input_string
	  	end

feature -- auxiliary queries

	etf_evt_out (evt: TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]): STRING
		local
			etf_local_i: INTEGER
			name: STRING
			args: ARRAY[ETF_EVT_ARG]
		do
			name := evt.name
			args := evt.args
			create Result.make_empty
			Result.append (name + "(")
			from
				etf_local_i := args.lower
			until
				etf_local_i > args.upper
			loop
				if args[etf_local_i].src_out.is_empty then
					Result.append (args[etf_local_i].out)
				else
					Result.append (args[etf_local_i].src_out)
				end
				if etf_local_i < args.upper then
					Result.append (", ")
				end
				etf_local_i := etf_local_i + 1
			end
			Result.append (")")
		end

feature -- attributes

	etf_error: BOOLEAN

	input_string: STRING -- list of commands to execute

	abstract_ui: ETF_ABSTRACT_UI_INTERFACE
		-- output generated by `parse_string'

feature -- error reporting

	on_error: ETF_EVENT [TUPLE[STRING]]

feature -- error messages

	input_cmds_syntax_err_msg : STRING =
		"Syntax Error: specification of command executions cannot be parsed"

	input_cmds_type_err_msg : STRING =
		"Type Error: specification of command executions is not type-correct"

feature -- parsing

	parse_and_validate_input_string
	  local
		trace_parser : ETF_EVT_TRACE_PARSER
		cmd : ETF_COMMAND_INTERFACE
		invalid_cmds: STRING
	  do
		create trace_parser.make (evt_param_types_list, enum_items)
		trace_parser.parse_string (input_string)

	    if trace_parser.last_error.is_empty then
	  	  invalid_cmds := find_invalid_evt_trace (
		    	trace_parser.event_trace)
		  if invalid_cmds.is_empty then
		    across trace_parser.event_trace
		    as evt
		    loop
		      cmd := evt_to_cmd (evt.item)
		      abstract_ui.put (cmd)
		    end
		  else
		    etf_error := TRUE
		    on_error.notify (
		  	  input_cmds_type_err_msg + "%N" + invalid_cmds)
		  end
	    else
	      etf_error := TRUE
	      on_error.notify (
		    input_cmds_syntax_err_msg + "%N" + trace_parser.last_error)
	    end
	end

	evt_to_cmd (evt : TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]) : ETF_COMMAND_INTERFACE
		local
			cmd_name : STRING
			args : ARRAY[ETF_EVT_ARG]
			dummy_cmd : ETF_DUMMY
		do
			cmd_name := evt.name
			args := evt.args
			create dummy_cmd.make("dummy", [], abstract_ui)

			if cmd_name ~ "test" then 
				 if attached {ETF_INT_ARG} args[1] as a_threshold and then 1 <= a_threshold.value and then a_threshold.value <= 101 and then attached {ETF_INT_ARG} args[2] as j_threshold and then 1 <= j_threshold.value and then j_threshold.value <= 101 and then attached {ETF_INT_ARG} args[3] as m_threshold and then 1 <= m_threshold.value and then m_threshold.value <= 101 and then attached {ETF_INT_ARG} args[4] as b_threshold and then 1 <= b_threshold.value and then b_threshold.value <= 101 and then attached {ETF_INT_ARG} args[5] as p_threshold and then 1 <= p_threshold.value and then p_threshold.value <= 101 then 
					 create {ETF_TEST} Result.make ("test", [a_threshold.value , j_threshold.value , m_threshold.value , b_threshold.value , p_threshold.value], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "play" then 
				 if TRUE then 
					 create {ETF_PLAY} Result.make ("play", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "abort" then 
				 if TRUE then 
					 create {ETF_ABORT} Result.make ("abort", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "move" then 
				 if attached {ETF_ENUM_INT_ARG} args[1] as dir and then (dir.value = N or else dir.value = NE or else dir.value = E or else dir.value = SE or else dir.value = S or else dir.value = SW or else dir.value = W or else dir.value = NW) then 
					 create {ETF_MOVE} Result.make ("move", [dir.value], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "land" then 
				 if TRUE then 
					 create {ETF_LAND} Result.make ("land", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "liftoff" then 
				 if TRUE then 
					 create {ETF_LIFTOFF} Result.make ("liftoff", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "pass" then 
				 if TRUE then 
					 create {ETF_PASS} Result.make ("pass", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "wormhole" then 
				 if TRUE then 
					 create {ETF_WORMHOLE} Result.make ("wormhole", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "status" then 
				 if TRUE then 
					 create {ETF_STATUS} Result.make ("status", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 
			else 
				 Result := dummy_cmd 
			end 
		end

	find_invalid_evt_trace (
		event_trace: ARRAY[TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]])
	: STRING
	local
		loop_counter: INTEGER
		evt: TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]
		cmd_name: STRING
		args: ARRAY[ETF_EVT_ARG]
		evt_out_str: STRING
	do
		create Result.make_empty
		from
			loop_counter := event_trace.lower
		until
			loop_counter > event_trace.upper
		loop
			evt := event_trace[loop_counter]
			evt_out_str := etf_evt_out (evt)

			cmd_name := evt.name
			args := evt.args

			if cmd_name ~ "test" then 
				if NOT( ( args.count = 5 ) AND THEN attached {ETF_INT_ARG} args[1] as a_threshold and then 1 <= a_threshold.value and then a_threshold.value <= 101 and then attached {ETF_INT_ARG} args[2] as j_threshold and then 1 <= j_threshold.value and then j_threshold.value <= 101 and then attached {ETF_INT_ARG} args[3] as m_threshold and then 1 <= m_threshold.value and then m_threshold.value <= 101 and then attached {ETF_INT_ARG} args[4] as b_threshold and then 1 <= b_threshold.value and then b_threshold.value <= 101 and then attached {ETF_INT_ARG} args[5] as p_threshold and then 1 <= p_threshold.value and then p_threshold.value <= 101) then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"test(a_threshold: THRESHOLD = 1 .. 101 ; j_threshold: THRESHOLD = 1 .. 101 ; m_threshold: THRESHOLD = 1 .. 101 ; b_threshold: THRESHOLD = 1 .. 101 ; p_threshold: THRESHOLD = 1 .. 101)")
				end

			elseif cmd_name ~ "play" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"play")
				end

			elseif cmd_name ~ "abort" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"abort")
				end

			elseif cmd_name ~ "move" then 
				if NOT( ( args.count = 1 ) AND THEN attached {ETF_ENUM_INT_ARG} args[1] as dir and then (dir.value = N or else dir.value = NE or else dir.value = E or else dir.value = SE or else dir.value = S or else dir.value = SW or else dir.value = W or else dir.value = NW)) then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"move(dir: DIRECTION = {N, NE, E, SE, S, SW, W, NW})")
				end

			elseif cmd_name ~ "land" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"land")
				end

			elseif cmd_name ~ "liftoff" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"liftoff")
				end

			elseif cmd_name ~ "pass" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"pass")
				end

			elseif cmd_name ~ "wormhole" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"wormhole")
				end

			elseif cmd_name ~ "status" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"status")
				end
			else
				if NOT Result.is_empty then
					Result.append ("%N")
				end
				Result.append ("Error: unknown event name " + cmd_name)
			end
			loop_counter := loop_counter + 1
		end
	end
end