# terraform-aws-teleport-storage [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-teleport-storage.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-teleport-storage)

## Introduction

This Terraform module provisions:

* An S3 bucket for session logs in Gravitational [Teleport](https://gravitational.com/teleport)
* An IAM policy with permissions to create and access a DynamoDB table to use as storage backend in Teleport

__NOTE:__ Teleport creates a DynamoDB table with the specified name automatically

https://gravitational.com/teleport/docs/admin-guide/


## Features

Using DynamoDB as a storage backend allows highly available deployments of Teleport Auth services.

Using S3 for Teleport session storage has many advantages:

* Encryption at rest
* Versioned objects
* Lifecycle Support to expunge old sessions (e.g. after 2 years)
* Extreme Availability & Durability
* Zero Maintenance
* Glacier
* Cross Region Replication
* S3 Bucket could be owned by tamper-proof AWS Audit Account
* Easily prevent deletions
* Audit Trails, Access Logs via Cloud Trails


## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-teleport-storage/issues), send us an [email](mailto:hello@cloudposse.com) or reach out to us on [Gitter](https://gitter.im/cloudposse/).


## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-teleport-storage/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing `terraform-aws-teleport-storage`, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

**NOTE:** Be sure to merge the latest from "upstream" before making a pull request!


## License

[APACHE 2.0](LICENSE) © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


## About

`terraform-aws-teleport-storage` is maintained and funded by [Cloud Posse, LLC][website].

![Cloud Posse](https://cloudposse.com/logo-300x69.png)


Like it? Please let us know at <hello@cloudposse.com>

We love [Open Source Software](https://github.com/cloudposse/)!

See [our other projects][community]
or [hire us][hire] to help build your next cloud-platform.

  [website]: http://cloudposse.com/
  [community]: https://github.com/cloudposse/
  [hire]: http://cloudposse.com/contact/

### Contributors


| [![Erik Osterman][erik_img]][erik_web]<br/>[Erik Osterman][erik_web] | [![Andriy Knysh][andriy_img]][andriy_web]<br/>[Andriy Knysh][andriy_web] |
|-------------------------------------------------------|------------------------------------------------------------------|

  [erik_img]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
  [erik_web]: https://github.com/osterman/
  [andriy_img]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
  [andriy_web]: https://github.com/aknysh/
