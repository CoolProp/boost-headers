# boost-headers

A minimal subset of [Boost](https://www.boost.org/) headers used by CoolProp
and related projects (teqp, superancillary). Extracted with Boost's
[`bcp`](https://www.boost.org/doc/libs/release/tools/bcp/doc/html/index.html)
tool so that consumers don't have to vendor the full Boost distribution.

Pin via CPM:

```cmake
CPMAddPackage(
  NAME boost_headers
  GIT_REPOSITORY https://github.com/CoolProp/boost-headers.git
  GIT_TAG        <sha-or-tag>
  DOWNLOAD_ONLY  YES
)
include_directories("${boost_headers_SOURCE_DIR}")
```

## What's included

The `bcp` header list lives in `Dockerfile`. Current set covers:

- `boost::math::tools::toms748_solve` + `eps_tolerance` (root finding)
- `boost::numeric::odeint` (ODE integration)
- `boost::variant`, `boost::optional`, `boost::operators`
- `boost::utility::string_ref` / `string_view`
- Supporting `boost::fusion`, `boost::mpl`, `boost::preprocessor`, `boost::predef`

## Regenerating

Requires Docker.

```
docker compose up --build
rm -rf boost && tar -xJf boost.tar.xz
```

unpacks a fresh `boost/` tree at the repo root. Commit the result and tag
a new release; downstream projects bump their CPM `GIT_TAG` to pick it up.

To add new headers, append them to the `bcp` invocation in `Dockerfile`
and regenerate. `bcp` pulls in transitive dependencies automatically.

## Boost version

Currently pinned to **1.87.0** (see `ARG BOOST_VERSION` in `Dockerfile`).
Bump the arg and regenerate to upgrade.

## License

The headers under `boost/` are distributed under the
[Boost Software License 1.0](https://www.boost.org/LICENSE_1_0.txt), a copy
of which is provided in `LICENSE`. The `Dockerfile`, `docker-compose.yml`,
and this `README.md` are contributed to the public domain.
