note
	description: "actionf_t from d_think.h"

class
	ACTIONF_T

create
	make_one

feature

	make_one (a_acp1: like acp1)
		do
			acp1 := a_acp1
		end

feature

	acp1: detachable PROCEDURE [TUPLE [ANY]] assign set_acp1

	set_acp1 (a_acp1: like acp1)
		do
			acp1 := a_acp1
		end

	acv: detachable PROCEDURE

	acp2: detachable PROCEDURE [TUPLE [ANY, ANY]]

end
