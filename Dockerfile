FROM gcc:7
ENV TZ=Asia/Tokyo

RUN apt-get -qq update && \
    apt-get -qq install \
        bc \
        bison \
        cpio \
        curl \
        elfutils \
        flex \
        libelf-dev \
        librpmbuild3 \
        rpm \
        rsync \
        sudo \
        wget

RUN usermod -s /bin/bash root && \
    groupadd -g 1000 mockbuild && \
    useradd -u 1000 -g mockbuild mockbuild && \
    usermod -s /bin/bash mockbuild && \
    echo 'mockbuild:$6$j0.6yx4Z$aSXtYtnZQN/h9UEhFxGzErmvdHDEWKcBWl41dtBNXqb0wr2.3kYRjfAp5jI76c6ooIDj524.bY5/EiMWLurWN.' | chpasswd -e && \
    echo 'mockbuild ALL=(ALL) NOPASSWD: ALL' | install --mode 0440 /dev/stdin /etc/sudoers.d/mockbuild

RUN curl -L https://github.com/tcnksm/ghr/releases/download/v0.10.0/ghr_v0.10.0_linux_amd64.tar.gz | \
    tar -zx --no-same-owner --no-same-permissions -C /usr/local/bin --strip-components=1 ghr_v0.10.0_linux_amd64/ghr

WORKDIR /home/mockbuild
RUN install --owner mockbuild --group mockbuild --mode 0701 -d /home/mockbuild \
    src tmp \
    rpmbuild/BUILD rpmbuild/BUILDROOT rpmbuild/RPMS rpmbuild/SOURCES rpmbuild/SPECS rpmbuild/SRPMS

USER mockbuild
CMD bash --login
