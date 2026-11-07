% Generated from an ArchiMate Model Exchange file.
% Source: vc.xml

% Elements
element("id-9f753c6e9cb1406fbfcd682a95d87533", "BusinessFunction").
name("id-9f753c6e9cb1406fbfcd682a95d87533", "Sales and Service Management").
element("id-2c2cb6a510ce4c54942bc77da89a7e5f", "BusinessFunction").
name("id-2c2cb6a510ce4c54942bc77da89a7e5f", "Personal Loan Agreement Management").
element("id-b257301ac76f44f0b5f8f98fc780627f", "BusinessFunction").
name("id-b257301ac76f44f0b5f8f98fc780627f", "Loan Administration").
element("id-109bde29b91b4f6aac6f83226cfdaf87", "BusinessService").
name("id-109bde29b91b4f6aac6f83226cfdaf87", "Requesting Loan Offer Service").
element("id-23994b6ee77240f2a4fa402c6fc3df9a", "BusinessService").
name("id-23994b6ee77240f2a4fa402c6fc3df9a", "Personal Loan Application Service").
element("id-37285b62ed3c417ab2376a3dcb25b2b3", "BusinessRole").
name("id-37285b62ed3c417ab2376a3dcb25b2b3", "Private Customer").
element("id-3dcb5d9c3aee48c39d9470134c0284af", "ApplicationComponent").
name("id-3dcb5d9c3aee48c39d9470134c0284af", "CRM Application").
element("id-405f6a4bd00e45f9abe8603dcb0325bc", "ApplicationService").
name("id-405f6a4bd00e45f9abe8603dcb0325bc", "Onboard new customer service").
element("id-9390a833427d4fccaed1d1a559c0e5ae", "DataObject").
name("id-9390a833427d4fccaed1d1a559c0e5ae", "Customer Data").
element("id-0a2b9afc3e5f4c1699dee17c0ebdcfc6", "ApplicationService").
name("id-0a2b9afc3e5f4c1699dee17c0ebdcfc6", "Retrieve customer data service").
element("id-c078e204209649eeb7d1cd8eff061a27", "ApplicationComponent").
name("id-c078e204209649eeb7d1cd8eff061a27", "Customer Portal").

% Relationships
relationship("id-c50def6b36104c50b2ed1a1a0cd9d962", "id-109bde29b91b4f6aac6f83226cfdaf87", "id-9f753c6e9cb1406fbfcd682a95d87533", "Serving").
relationship("id-9f8d22e6b05b4b849c5c0f4220bf716f", "id-9f753c6e9cb1406fbfcd682a95d87533", "id-23994b6ee77240f2a4fa402c6fc3df9a", "Realization").
relationship("id-8f9bb7f4451046d1a146a0901f779d58", "id-23994b6ee77240f2a4fa402c6fc3df9a", "id-37285b62ed3c417ab2376a3dcb25b2b3", "Serving").
relationship("id-1de0a3abce4c4e7fbc85a36650f56657", "id-2c2cb6a510ce4c54942bc77da89a7e5f", "id-109bde29b91b4f6aac6f83226cfdaf87", "Realization").
relationship("id-4702fd86a2bf44b7a7c2a77405150135", "id-b257301ac76f44f0b5f8f98fc780627f", "id-2c2cb6a510ce4c54942bc77da89a7e5f", "Serving").
relationship("id-118bd1d184134492b0720ece3839d31f", "id-3dcb5d9c3aee48c39d9470134c0284af", "id-9390a833427d4fccaed1d1a559c0e5ae", "Access").
relationshipAttribute("id-118bd1d184134492b0720ece3839d31f", "accessType", "ReadWrite").
relationship("id-0e703d464d8a4c408549b5fcc5e7f595", "id-3dcb5d9c3aee48c39d9470134c0284af", "id-405f6a4bd00e45f9abe8603dcb0325bc", "Realization").
relationship("id-1a9fd83a5da8477e9974cd2ee8c50d76", "id-3dcb5d9c3aee48c39d9470134c0284af", "id-0a2b9afc3e5f4c1699dee17c0ebdcfc6", "Realization").
relationship("id-bbefde793d20443391479e79e3917f47", "id-c078e204209649eeb7d1cd8eff061a27", "id-9390a833427d4fccaed1d1a559c0e5ae", "Access").
relationshipAttribute("id-bbefde793d20443391479e79e3917f47", "accessType", "Read").
relationship("id-a04d994273d34d7797653192c706ed1a", "id-405f6a4bd00e45f9abe8603dcb0325bc", "id-c078e204209649eeb7d1cd8eff061a27", "Serving").
