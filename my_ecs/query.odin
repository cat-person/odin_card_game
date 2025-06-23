#+feature dynamic-literals
package my_ecs

import "core:log"

Query :: map[EntityId][dynamic]byte // refactor dynamic

handle_query :: proc {
	handle_query1,
	handle_query2,
}
