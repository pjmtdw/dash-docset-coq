FROM fedora:33

# ocaml-camlp5-devel seems not required by current master branch of Coq
RUN dnf -y --setopt=install_weak_deps=False install findutils make ocaml ocaml-num-devel \
                    ocaml-findlib python3 python3-setuptools python3-pip ocaml-camlp5-devel ocaml-zarith-devel

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

COPY coq_parser.py /store/

ARG COQ_VER=8.13.0

ADD https://github.com/coq/coq/archive/V${COQ_VER}.tar.gz coq.tar.gz
RUN mkdir /coq && tar zxf coq.tar.gz -C /coq --strip-components=1

WORKDIR /coq

# consider using -no-ask option which is added in recent coq, instead of specifing all options
RUN ./configure -prefix /usr -mandir /usr/share/man -configdir /etc/xdg/coq/ -coqide no -with-doc yes

# Default sphinx theme for coq which is sphinx_rtd_theme, seems no way to disable sidebar, so we use alabaster instead
RUN make -j4 SPHINXOPTS="-Dhtml_theme=alabaster -Dhtml_theme_options.nosidebar=true" doc-html

RUN LANG=C.UTF-8 LC_ALL=C.UTF-8 PYTHONPATH=/store/ doc2dash -n Coq -i ./ide/coqide/coq.png \
         --parser coq_parser.CoqSphinxParser ./doc/sphinx/_build/html
