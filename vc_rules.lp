% Principle 1
% Implication 1
#const pr_1_id = "BusFuncsWorkTogetherThroughBusSrvcs".
#const pr_1_impl_1_id = "BusFuncsRealizeBusSrvcs".

bus_func_realizes_bus_srvc(BFID) :-
	element(BFID, "BusinessFunction"),	
	element(BSID, "BusinessService"),
	relationship(RELID, BFID, BSID, "Realization").

violation(pr_1_id, pr_1_impl_1_id) :-
	element(BFID, "BusinessFunction"),	
	not bus_func_realizes_bus_srvc(BFID).
evidence(pr_1_id, pr_1_impl_1_id, element(
	BFID)) :-
	element(BFID, "BusinessFunction"),
	not bus_func_realizes_bus_srvc(BFID).

violation_report_element(pr_1_id,pr_1_impl_1_id, BFID, NAME) :-
	violation(pr_1_id, pr_1_impl_1_id),
	evidence(pr_1_id, pr_1_impl_1_id,
	element(BFID)),
	name(BFID, NAME).

#const pr_1_impl_2_id = "NoDirectRelationBusFunctions".

violation(pr_1_id, pr_1_impl_2_id) :-
	element(BFID1, "BusinessFunction"),
	element(BFID2, "BusinessFunction"),
	relationship(RELID, BFID1, BFID2, _).

evidence(pr_1_id, pr_1_impl_2_id, relationship(RELID)) :-
	element(BFID1, "BusinessFunction"),
	element(BFID2, "BusinessFunction"),
	relationship(RELID, BFID1, BFID2, _).

violation_report_relation(pr_1_id, pr_1_impl_2_id, RELID, NAME1, NAME2, TYPE) :-
	evidence(pr_1_id, pr_1_impl_2_id,	
	relationship(RELID)),
	relationship(RELID, SOURCEID, TARGETID, TYPE),
	name(SOURCEID, NAME1),
	name(TARGETID, NAME2).

#const pr_2_id = "ApplicationsNoDirectDBAccess".
#const pr_2_impl_1_id = "AppCompsRealizeAppSrvcs".

app_comp_realizes_app_srvc(ACID) :-
	element(ACID, "ApplicationComponent"),
	element(ASID, "ApplicationService"),
	relationship(RELID, ACID, ASID, "Realization").

violation(pr_2_id, pr_2_impl_1_id) :-
	element(ACID, "ApplicationComponent"),
	not app_comp_realizes_app_srvc(ACID).

evidence(pr_2_id, pr_2_impl_1_id, element(ACID)) :-
	element(ACID, "ApplicationComponent"),
	not app_comp_realizes_app_srvc(ACID).

violation_report_element(pr_2_id, pr_2_impl_1_id, ACID, NAME) :-
	evidence(pr_2_id, pr_2_impl_1_id, element(ACID)),
	name(ACID, NAME).

#const pr_2_impl_2_id = "DataObjDirectAccess".

violation(pr_2_id, pr_2_impl_2_id) :-
	element(SOURCEID1, "ApplicationComponent"),
	element(SOURCEID2, "ApplicationComponent"),
	element(DOBJID, "DataObject"),
	relationship(RELID1, SOURCEID1, DOBJID, "Access"),
	relationship(RELID2, SOURCEID2, DOBJID, "Access"),
	relationshipAttribute(RELID1, "accessType", ("ReadWrite";"Write")),
	SOURCEID1 != SOURCEID2.

evidence(pr_2_id, pr_2_impl_2_id, data_access(DOBJID, SOURCEID1, SOURCEID2)) :-
	element(SOURCEID1, "ApplicationComponent"),
	element(SOURCEID2, "ApplicationComponent"),
	element(DOBJID, "DataObject"),
	relationship(RELID1, SOURCEID1, DOBJID, "Access"),
	relationship(RELID2, SOURCEID2, DOBJID, "Access"),
	relationshipAttribute(RELID1, "accessType", ("ReadWrite";"Write")),
	SOURCEID1 != SOURCEID2.

violation_report_relation(pr_2_id, pr_2_impl_2_id, NAME1, NAME2, NAME3) :-
	evidence(pr_2_id, pr_2_impl_2_id, data_access(DOBJID, SOURCEID1, SOURCEID2)),
	name(SOURCEID1, NAME1),
	name(DOBJID, NAME2),
	name(SOURCEID2, NAME3).

