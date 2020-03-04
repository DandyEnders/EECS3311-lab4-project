note
	description: "[
		Directed Graph implemented as Adjacency List 
	    in generic parameter G that is Comparable:
			vertices: LIST[VERTEX[G]]
			edges: ARRAY [EDGE [G]]
			-- commands
			add_edge (e: EDGE [G])
			add_vertex (v: VERTEX [G])
			remove_edge (a_edge: EDGE [G])
			remove_vertex (a_vertex: VERTEX [G])
			
			A vertex has outgoing and incoming edges.
			An edge has a source vertex and destination vertex.
			Vertices and Edges must be attached.
		]"
	ca_ignore: "CA023", "CA023: Undeed parentheses", "CA017", "CA107: Empty compound after then part of if"
	author: "JSO and JW and Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	LIST_GRAPH[G -> COMPARABLE]
inherit
	ITERABLE[VERTEX[G]]
		redefine out end

	DEBUG_OUTPUT
		redefine out end

create
	make_empty

feature -- Model

	model: COMPARABLE_GRAPH[VERTEX[G]]
			-- abstraction function
		do
			-- Make empty output
			create Result.make_empty

			-- Put vertices
			across
				vertices is i_vertex
			loop
				Result.vertex_extend (i_vertex)
			end

			-- Put edges
			across
				edges is i_edge
			loop
				Result.edge_extend ([i_edge.source, i_edge.destination])
			end
				-- done.
		ensure
			comment("Establishes model consistency invariants")
		end

feature {NONE} -- Initialization

	make_empty
			-- create empty graph
		do
			create {LINKED_LIST[VERTEX[G]]} vertices.make
			vertices.compare_objects
		ensure
			mm_empty_graph: model.is_empty
		end


feature -- Iterator Pattern
	new_cursor: ITERATION_CURSOR [VERTEX[G]]
		do
			Result := vertices.new_cursor
		end

feature -- queries

	get_vertex(g: G): detachable VERTEX[G]
			-- Return the associated vertext object storing `g`, if any.
			-- Note. In the invariant, it is asserted that all vertices are unique.
		do
			-- Check across the vertex and see if that vertex has item g.
			across
				vertices as l_vertex
			loop
				if l_vertex.item.item ~ g then
					Result := l_vertex.item
				end
			end
			-- done.
		ensure
			mm_attached:
				attached Result implies model.has_vertex (create {VERTEX[G]}.make (g))
			mm_not_attached:
				not attached Result implies not model.has_vertex (create {VERTEX[G]}.make (g))
		end

	vertices: LIST[VERTEX[G]]

	vertex_count: INTEGER
			-- number of vertices
		do
			-- Just return the count.
			Result := vertices.count
			-- done.
		ensure
			mm_vertex_count: Result = model.vertex_count
		end

	edge_count: INTEGER
			-- number of outgoing edges
		do
			-- Just return the edges count.
			Result := edges.count
			-- done.
		ensure
			mm_edge_count: Result = model.edge_count
		end

	is_empty: BOOLEAN
			-- does the graph contain no vertices?
		do
			-- See if vertex is empty.
			Result := vertices.is_empty
			-- done.
		ensure
			comment ("See invariant empty_consistency")
			mm_is_empty: Result = model.is_empty
		end

	has_vertex(a_vertex: VERTEX[G]): BOOLEAN
		do
			Result := vertices.has (a_vertex)
			-- done.
		ensure
			mm_has_vertex: Result = model.has_vertex (a_vertex)
		end

	has_edge(a_edge: EDGE[G]): BOOLEAN
		do
			Result := edges.has (a_edge)
			-- done.
		ensure
			mm_has_edge: Result = model.has_edge ([a_edge.source, a_edge.destination])
		end

	edges: ARRAY[EDGE[G]]
			-- array of all outgoing edges
		do
			-- For all vertices, check for its outgoing edges.
			create Result.make_empty
			across
				vertices as l_vertex
			loop
				across
					l_vertex.item.outgoing as l_edge
				loop
					Result.force (l_edge.item, Result.count + 1)
				end
			end
			Result.compare_objects
			-- done.
		ensure
			mm_edges_count:
				Result.count = model.edge_count
			mm_edges_membership:
				across Result as l_edge all
					model.has_edge ([l_edge.item.source, l_edge.item.destination])
				end
		end

feature -- Advanced Queries

	topologically_sorted: ARRAY [VERTEX [G]]
			-- Return an array <<..., vi, ..., vj, ...>> such that
			-- (vi, vj) in edges => i < j
			-- A topological sort is performed.
		require
			is_acyclic: model.is_acyclic

		local
			clone_vertices: LIST[VERTEX[G]]
			queue: LINKED_LIST[VERTEX[G]]
			front: VERTEX[G]

			u: VERTEX[G]
		do
			from
				create Result.make_empty
				-- init queue, clone vertices, find all non-incoming vertex
				create queue.make
				clone_vertices := vertices.deep_twin
				across clone_vertices is i_vertex loop
					if (i_vertex.incoming_edge_count = 0) then
						queue.force(i_vertex)
					end
				end
			until
				queue.is_empty
			loop
				front := queue.first -- get first
				queue.prune_all (queue.first) -- remove front of queue
				Result.force (front, (Result.count + 1)) -- append front

				across
					front.outgoing_sorted is i_out_edge -- get the outgoing edge
				loop
					u := i_out_edge.destination 	-- get u
					u.remove_edge (i_out_edge)		-- remove edge from u
					if(u.incoming_edge_count = 0) then
						queue.force(u)
					end
				end
			end
			Result.compare_objects
			-- done.
		ensure
			mm_sorted: Result ~ model.topologically_sorted.as_array
		end

	is_topologically_sorted (seq: like topologically_sorted): BOOLEAN
			-- does `seq` represent a topological order of the current graph?
		local
			count_same: BOOLEAN
			vertex_same: BOOLEAN
			former_smaller: BOOLEAN
		do
			-- size same?
			count_same := seq.count = vertices.count
			Result := count_same

			-- vertex same?
			vertex_same :=
				across
					seq is i_vertex
				all
					vertices.has (i_vertex)
				end
			Result := Result and vertex_same

			-- actual definition of topologically sorted.
			-- every edge from vertices from left to right has outgoing edges to only right.
			former_smaller :=
				across
					1 |..| seq.count as former	-- former is a list with a pointer on it
				all
					across
						1 |..| seq.count as latter
					all
						former.item ~ latter.item or else (has_edge(create {EDGE[G]}.make(seq[former.item], seq[latter.item])) implies former.item < latter.item)
					end
				end
			Result := Result and former_smaller

			-- done.
			ensure
				sorted: Result ~ model.is_topologically_sorted (seq)
		end

	shortest_path (src: VERTEX[G]; dest: VERTEX[G]): ARRAY[VERTEX[G]]
		require
			reachable(src).has (dest)
		local
			parents: ARRAY[EDGE[G]]
			current_vertex: VERTEX[G]
			done_finding_path: BOOLEAN

			result_stack: ARRAYED_STACK[VERTEX[G]]

			my_src, my_dest: VERTEX[G]
		do
			parents := reachable_edges(src, dest)
			create Result.make_empty
			Result.compare_objects

			create result_stack.make (0)

			my_src := get_vertex(src.item)
			my_dest := get_vertex(dest.item)

			if attached my_src as att_my_src and attached my_dest as att_my_dest then
				from
					current_vertex := att_my_dest
					result_stack.force (current_vertex)
				until
					done_finding_path
				loop
					if current_vertex ~ my_src then
						done_finding_path := true
					else
						across
							parents is i_edge
						loop
							if i_edge.destination ~ current_vertex then
								current_vertex := i_edge.source
								result_stack.force (current_vertex)
							end
						end
					end
				end
			end

			from

			until
				result_stack.is_empty
			loop
				Result.force(result_stack.item, Result.count + 1)
				result_stack.remove
			end

		end

	reachable_edges (src: VERTEX[G]; dest: VERTEX[G]): ARRAY[EDGE[G]]
		require
			reachable(src).has (dest)
		local
			-- my_src, the actual graph's starting point
			-- queue, the searching queue
			-- front, the "current" searching vertex
			my_src: VERTEX[G]
			visited: ARRAY[VERTEX[G]]
			queue: LIST[VERTEX[G]]
			front: VERTEX[G]
			parents: ARRAY[EDGE[G]]
		do
			my_src := get_vertex(src.item)
			create {LINKED_LIST[VERTEX[G]]} queue.make
			create visited.make_empty

			create parents.make_empty

			visited.compare_objects
			-- We do BFS. no parent and distance because we dont need them.
			if attached my_src as src_att then
				from
					visited.force (src_att, visited.count + 1)
					queue.force (src_att)
				until
					queue.is_empty
				loop
					front := queue.first
					queue.prune_all (queue.first)
					across front.outgoing_sorted is l_edge
					loop
						if not visited.has (l_edge.destination) then
							-- I make sure that what I return is not the actual vertex in graph.
							visited.force (create {VERTEX[G]}.make(l_edge.destination.item) , visited.count + 1)
							parents.force (l_edge, parents.count + 1)
							queue.force (l_edge.destination)
						end
					end
				end
			end

			Result := parents
		end

feature -- advanced queries (Lab 1)

	reachable (src: VERTEX [G]): ARRAY [VERTEX [G]]
			-- Starting with vertex `src`, return the list of vertices visited via a breadth-first search.
			-- It is required that `outgoing_sorted` is used for each vertex to reach out to its neighbouring vertices,
			-- so that the resulting array is uniquely ordered.
			-- Note. `outgoing_sorted` is somewhat analogous to `adjacent` in the abstract algorithm documentation of BFS.
		require
			mm_existing_source: model.has_vertex (src)
		local
			-- my_src, the actual graph's starting point
			-- queue, the searching queue
			-- front, the "current" searching vertex
			my_src: VERTEX[G]
			visited: ARRAY[VERTEX[G]]
			queue: LIST[VERTEX[G]]
			front: VERTEX[G]
		do
			my_src := get_vertex(src.item)
			create {LINKED_LIST[VERTEX[G]]} queue.make
			create visited.make_empty

			visited.compare_objects
			-- We do BFS. no parent and distance because we dont need them.
			if attached my_src as src_att then
				from
					visited.force (src_att, visited.count + 1)
					queue.force (src_att)
				until
					queue.is_empty
				loop
					front := queue.first
					queue.prune_all (queue.first)
					across front.outgoing_sorted is l_edge
					loop
						if not visited.has (l_edge.destination) then
							-- I make sure that what I return is not the actual vertex in graph.
							visited.force (create {VERTEX[G]}.make(l_edge.destination.item) , visited.count + 1)
							queue.force (l_edge.destination)
						end
					end
				end
			end
			Result := visited
				-- done
		ensure
			mm_reachable_in_model: model.reachable (src).as_array ~ Result
		end



feature -- commands

	add_vertex(a_vertex: VERTEX[G])
		require
			mm_non_existing_vertex:
				not model.has_vertex (a_vertex)
		do
			vertices.force (create {VERTEX[G]}.make (a_vertex.item))
			-- done.
		ensure
			mm_vertex_added:
				model ~ (old model.deep_twin) + a_vertex
		end

	add_edge(a_edge: EDGE[G])
		require
			mm_existing_source_vertex:
				model.has_vertex (a_edge.source)
			mm_existing_destination_vertex:
				model.has_vertex (a_edge.destination)
			mm_non_existing_edge:
				not model.has_edge ([a_edge.source, a_edge.destination])
		local
			src, dst: VERTEX [G]
			new_edge: EDGE [G]
		do
			-- Find src and dst from our graph. We are gurenteed to find it by the precondition.
			src := get_vertex(a_edge.source.item)
			dst := get_vertex(a_edge.destination.item)

			if attached src as src_att and attached dst as dst_att then
				-- Make new edge.
				create new_edge.make (src_att, dst_att)

				-- If there is a self loop, adding one edge is sufficient.
				src_att.add_edge (new_edge)

				-- If there is no self loop, we have to add the edge on the other vertex.
				--if not new_edge.is_self_loop then
				if not (new_edge.source ~ new_edge.destination) then
					dst_att.add_edge (new_edge)
				end
			end
			-- done.
		ensure
			mm_edge_added:
				model ~ (old model.deep_twin) |\/| [a_edge.source, a_edge.destination]
		end

	remove_edge(a_edge: EDGE[G])
		require
			mm_existing_edge:
				model.has_edge ([a_edge.source, a_edge.destination])
		do
			across vertices is l_vertex
			loop
				-- I gurentee the precondition for using remove_edge for each vertex.
				if l_vertex.has_incoming_edge(a_edge) or l_vertex.has_outgoing_edge(a_edge) then
					l_vertex.remove_edge(a_edge)
				end
			end
			-- done.
		ensure
			mm_edge_removed:
				model ~ (old model.deep_twin) |\ [a_edge.source, a_edge.destination]
		end

	remove_vertex(a_vertex: VERTEX[G])
		require
			mm_existing_vertex:
				model.has_vertex (a_vertex)
		local
			v: VERTEX [G]
		do
			-- I grab the vertex, go through incoming and outgoing and remove all edges on them.
			-- remove_edge will ensure that source's and destination's edges removed.
			v := get_vertex(a_vertex.item)
			if attached v as v_att then
				-- Instead of using across, we used from until loop
				-- keep "poping" them out until they are empty.
				from
				until
					v_att.incoming.count = 0
				loop
					remove_edge(v_att.incoming[1])
				end

				from
				until
					v_att.outgoing.count = 0
				loop
					remove_edge(v_att.outgoing[1])
				end

				-- Finally, when the vertex is isolated in graph, we remove it.
				vertices.prune_all (v_att)
			end
			-- done.
		ensure
			mm_vertex_removed:
				model ~ (old model.deep_twin) - a_vertex
		end

feature -- out

	comment(s: STRING): BOOLEAN
		do
			Result := true
		end

	debug_output: STRING
		do
			Result := ""
			across vertices as l_vertex loop
				Result := Result + "[" + l_vertex.item.debug_output + "]"
			end
		end

	out: STRING
		do
			Result := ""
			across vertices as l_vertex loop
				Result := Result + "[" + l_vertex.item.out + "]"
			end

		end

feature -- agent functions

	vertices_edge_count: INTEGER
			-- total number of incoming and outgoing edges of all vertices in `vertices`
			-- Result = (Σv ∈ vertices : v.outgoing_edge_count + v.incoming_edge_count)
		do
			Result := vertices_outgoing_edge_count + vertices_incoming_edge_count
		end

	vertices_outgoing_edge_count: INTEGER
			-- total number of outgoing edges of all vertices in `vertices`
			-- Result = (Σv ∈ vertices : v.outgoing_edge_count)
		do
			Result := {NUMERIC_ITERABLE[VERTEX[G]]}.sumf(
								vertices,
								agent (v: VERTEX[G]): INTEGER
									do
										Result := v.outgoing_edge_count
									end)
		end

	vertices_incoming_edge_count: INTEGER
			-- total number of incoming edges of all vertices in `vertices`
			-- Result = (Σv ∈ vertices : v.incoming_edge_count)
		do
			Result := {NUMERIC_ITERABLE[VERTEX[G]]}.sumf(
								vertices,
								agent (v: VERTEX[G]): INTEGER
									do
										Result := v.incoming_edge_count
									end)
		end

invariant
	empty_consistency:
		vertices.count = 0 implies edges.count = 0

	vertex_count = vertices.count

	vertices.lower = 1

	unique_vertices:
		across 1 |..| vertex_count as i all
		across 1 |..| vertex_count as j all
		i.item /= j.item implies vertices[i.item] /~ vertices[j.item]
		end
		end

	consistency_incoming_outgoing:
		across vertices is l_vertex all
			across l_vertex.outgoing is l_edge all
				l_edge.destination.has_incoming_edge(l_edge)
			end
			and
			across l_vertex.incoming is l_edge all
				l_edge.source.has_outgoing_edge(l_edge)
			end
		end

	consistency_incoming_outgoing2:
		-- ∀e ∈ edges:
		--	   ∧ e ∈ e.source.outgoing
		--	   ∧ e ∈ e.destination.incoming
		across edges as l_edge all
			l_edge.item.source.has_outgoing_edge(l_edge.item)
			and
			l_edge.item.destination.has_incoming_edge(l_edge.item)
		end

	model_consistency_vertex_count:
		model.vertex_count = vertex_count

	model_consistency_edge_count:
		model.edge_count = edge_count

	model_consistency_vertices:
		across model.vertices as l_v all
			has_vertex (l_v.item)
		end

	model_consistency_edges:
		across model.edges as l_e all
			has_edge ([l_e.item.first, l_e.item.second])
		end

	count_property_symmetry_1: -- (Σv ∈ vertices : v.outgoing_edge_count + v.incoming_edge_count) = 2 * edge_count
		vertices_edge_count = 2 * edge_count

	count_property_symmetry_2: -- (Σv ∈ vertices : v.outgoing_edge_count) = (Σv ∈ vertices : v.incoming_edge_count)
		vertices_outgoing_edge_count = vertices_incoming_edge_count

	self_loops_are_incomng_and_outgoing:
		across
			vertices is l_vertex
		all
			across l_vertex.incoming is l_edge  some
				l_edge.source ~ l_edge.destination
			end
			=
			across l_vertex.outgoing is l_edge  some
				l_edge.source ~ l_edge.destination
			end
		end
end
