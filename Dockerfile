FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
      make ocaml ocaml-findlib python3 python3-setuptools python3-pip

# actually we don't need sphinx_rtd_theme==0.4.2, since we will use alabaster theme instead
RUN pip3 install 'Sphinx==1.8.2' 'sphinx_rtd_theme==0.4.2' 'sphinxcontrib-bibtex==0.4.1' \
      'beautifulsoup4==4.6.3' 'pexpect==4.6.0' 'antlr4-python3-runtime==4.7.1' 'doc2dash==2.3.0'

COPY coq_parser.py comp_ver.sh /store/

ARG COQ_VER=8.9+beta1

# required for building version <= V8.9+beta1
#   https://github.com/coq/coq/issues/9050

RUN /bin/bash /store/comp_ver.sh ${COQ_VER} gt 8.9~beta1 || apt-get install -y --no-install-recommends camlp5

# required for building version <= 8.8.2
#   https://github.com/coq/coq/pull/7466
RUN /bin/bash /store/comp_ver.sh ${COQ_VER} gt 8.8.2 || apt-get install -y --no-install-recommends hevea

ADD https://github.com/coq/coq/archive/V${COQ_VER}.tar.gz coq.tar.gz
RUN mkdir /coq && tar zxf coq.tar.gz -C /coq --strip-components=1

WORKDIR /coq

# consider using -no-ask option which is added in recent coq, instead of specifing all options
RUN ./configure -prefix /usr -mandir /usr/share/man -configdir /etc/xdg/coq/ -coqide no -with-doc yes 

# Default sphinx theme for coq which is sphinx_rtd_theme, seems no way to disable sidebar, so we use alabaster instead
RUN make -j4 SPHINXOPTS="-Dhtml_theme=alabaster -Dhtml_theme_options.nosidebar=true" doc-html

RUN LANG=C.UTF-8 LC_ALL=C.UTF-8 PYTHONPATH=/store/ doc2dash -n Coq -i ./ide/coq.png \
         --parser coq_parser.CoqSphinxParser ./doc/sphinx/_build/html
