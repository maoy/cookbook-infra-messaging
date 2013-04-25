Description
===========

Installs/Configures infra-messaging

Requirements
============

* nova
* openstack-common
* rabbitmq

Attributes
==========

Usage
=====

```json
"run_list": [
    "recipe[infra-messaging]"
]
```

default
----

Installs/Configures infra-messaging

Testing
=====

This cookbook is using [ChefSpec](https://github.com/acrmp/chefspec) for
testing. Run the following before commiting. It will run your tests,
and check for lint errors.

    % ./run_tests.bash

License and Author
==================

Author:: John Dewey (<john@dewey.ws>)

Copyright 2013, AT&T Services, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and 
limitations under the License.
