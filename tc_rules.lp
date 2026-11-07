#const pr_1_impl_2_id = "NoDirectRelationProcess".

violation(pr_1_id, pr_1_impl_2_id) :-
	element(PRID, "BusinessProcess"),
	element(ACID, "ApplicationComponent"),
	relationship(RELID, ACID, PRID, _).

evidence(pr_1_id, pr_1_impl_2_id, relationship(RELID)) :-
	element(PRID, "BusinessProcess"),
	element(ACID, "ApplicationComponent"),
	relationship(RELID, ACID, PRID, _).

violation_report_relation(pr_1_id, pr_1_impl_2_id, RELID, NAME1, NAME2, TYPE) :-
	evidence(pr_1_id, pr_1_impl_2_id, relationship(RELID)),
	relationship(RELID, SOURCEID, TARGETID, TYPE),
	name(SOURCEID, NAME1),
	name(TARGETID, NAME2).

violation(pr_1_id, pr_1_impl_2_id) :-
	element(PRID, "BusinessProcess"),
	element(AFID, "ApplicationFunction"),
	relationship(RELID, AFID, PRID, _).

evidence(pr_1_id, pr_1_impl_2_id, relationship(RELID)) :-
	element(PRID, "BusinessProcess"),
	element(AFID, "ApplicationFunction"),
	relationship(RELID, AFID, PRID, _).

violation_report_relation(pr_1_id, pr_1_impl_2_id, RELID, NAME1, NAME2, TYPE) :-
	evidence(pr_1_id, pr_1_impl_2_id,
	relationship(RELID)),
	relationship(RELID, SOURCEID, TARGETID, TYPE),
	name(SOURCEID, NAME1),
	name(TARGETID, NAME2).

#const pr_1_impl_7_id = "NoDirectRelationAppComp".

violation(pr_1_id, pr_1_impl_7_id) :-
	element(ACID1, "ApplicationComponent"),
	element(ACID2, "ApplicationComponent"),
	relationship(RELID, ACID1, ACID2, "Serving").

evidence(pr_1_id, pr_1_impl_7_id, relationship(RELID)) :-
	element(ACID1, "ApplicationComponent"),
	element(ACID2, "ApplicationComponent"),
	relationship(RELID, ACID1, ACID2, "Serving").

violation_report_relation(pr_1_id, pr_1_impl_7_id, RELID, NAME1, NAME2, TYPE) :-
	evidence(pr_1_id, pr_1_impl_7_id, relationship(RELID)),
	relationship(RELID, SOURCEID, TARGETID, TYPE),
	name(SOURCEID, NAME1),
	name(TARGETID, NAME2).

violation(pr_1_id, pr_1_impl_7_id) :-
	element(ACID, "ApplicationComponent"),
	element(AFID, "ApplicationFunction"),
	relationship(RELID, ACID, AFID, "Serving").

evidence(pr_1_id, pr_1_impl_7_id, relationship(RELID)) :-
	element(ACID, "ApplicationComponent"),
	element(AFID, "ApplicationFunction"),
	relationship(RELID, ACID, AFID, "Serving").

violation_report_relation(pr_1_id, pr_1_impl_7_id, RELID, NAME1, NAME2, TYPE) :-
	evidence(pr_1_id, pr_1_impl_7_id, relationship(RELID)),
	relationship(RELID, SOURCEID, TARGETID, TYPE),
	name(SOURCEID, NAME1),
	name(TARGETID, NAME2).

#const pr_2_impl_2_id = "EachAppCompAppFunc".

app_comp_assigned_app_func(ACID) :-
	element(ACID, "ApplicationComponent"),
	element(AFID, "ApplicationFunction"),
	relationship(RELID, ACID, AFID, "Assignment").

violation(pr_2_id, pr_2_impl_2_id) :-
	element(ACID, "ApplicationComponent"),
	not app_comp_assigned_app_func(ACID).

evidence(pr_2_id, pr_2_impl_2_id, element(ACID, "ApplicationComponent")) :-
	element(ACID, "ApplicationComponent"),
	not app_comp_assigned_app_func(ACID).

violation_report_relation(pr_2_id, pr_2_impl_2_id, ACID, NAME) :-
	evidence(pr_2_id, pr_2_impl_2_id, element(ACID, "ApplicationComponent")),
	name(ACID, NAME).



