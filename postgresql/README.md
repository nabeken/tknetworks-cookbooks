Description
===========

Installs and configures PostgreSQL as a client or a server.

This cookbook is based on opscode/cookbook/postgresql.

Requirements
============

## Platforms

* Debian, Ubuntu

## Cookboooks

Requires Opscode's `openssl` cookbook for secure password generation.

Requires a C compiler and development headers in order to build the
`pg` RubyGem to provide Ruby bindings so they're available in other
cookbooks.

Opscode's `build-essential` cookbook provides this functionality on
Debian, Ubuntu, and EL6-family.

While not required, Opscode's `database` cookbook contains resources
and providers that can interact with a PostgreSQL database. This
cookbook is a dependency of that one.


License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Lamont Granquist (<lamont@opscode.com>)
Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
