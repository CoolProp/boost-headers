## Use `docker compose up --build` to regenerate `boost.tar.xz` in the
## working directory, via Boost's bcp tool. Then:
##   rm -rf boost && tar -xJf boost.tar.xz
## to refresh the unpacked `boost/` tree.
##
## Bump the boost version below and the `bcp` argument list to adjust the
## subset. Commit the regenerated tree and tag a release; CoolProp (and
## any other consumer) pins the tag via CPM.

FROM ubuntu:24.04

RUN apt-get -y -m update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        cmake g++ git zip wget xz-utils

ARG BOOST_VERSION=1.87.0
ARG BOOST_UNDERSCORE=1_87_0

RUN mkdir /boost && \
    wget -c --no-check-certificate \
        https://archives.boost.io/release/${BOOST_VERSION}/source/boost_${BOOST_UNDERSCORE}.tar.gz \
        -O - | tar -xz -C /boost && \
    cd /boost/boost_${BOOST_UNDERSCORE}/ && \
    ./bootstrap.sh && \
    ./b2 tools/bcp

WORKDIR /boost/boost_1_87_0/
RUN mkdir /out && \
    dist/bin/bcp \
        predef/other/endian.h \
        boost/fusion/sequence/intrinsic/size.hpp \
        boost/fusion/algorithm/iteration/for_each.hpp \
        boost/fusion/include/mpl.hpp \
        boost/fusion/sequence/intrinsic/at.hpp \
        boost/utility/string_ref.hpp \
        boost/utility/string_view.hpp \
        boost/mpl/size.hpp \
        boost/variant.hpp \
        boost/assert.hpp \
        boost/preprocessor.hpp \
        boost/fusion/support/is_sequence.hpp \
        boost/optional.hpp \
        boost/operators.hpp \
        boost/version.hpp \
        math/tools/toms748_solve.hpp \
        boost/numeric/odeint.hpp \
        typeof \
        /out && \
    cd /out && tar cJf /boost.tar.xz boost

CMD cp /boost.tar.xz /output/
