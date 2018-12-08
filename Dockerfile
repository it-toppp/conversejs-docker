FROM nginx

# Setup and install conversejs (https://conversejs.org) and
# the BOSH connection manager punjab (https://github.com/twonds/punjab)

RUN apt-get update -y
RUN apt-get install -y curl python-twisted python-openssl git

WORKDIR /tmp

RUN git clone https://github.com/conversejs/converse.js.git

RUN cp /tmp/converse.js-*/css/converse.min.css /usr/share/nginx/html/
RUN cp /tmp/converse.js-*/builds/converse.min.js /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/

RUN curl -L https://github.com/twonds/punjab/archive/v0.15.tar.gz -o /tmp/punjab_v0.15.tar.gz && \
  echo "9b2e9bc45bd409e1414ecc3b653d341c271ef704  /tmp/punjab_v0.15.tar.gz" | sha1sum -c - && \
  tar xfv /tmp/punjab_v0.15.tar.gz && rm -f /tmp/punjab_v0.15.tar.gz

RUN cd punjab-0.15 && python setup.py install

RUN rm /etc/nginx/conf.d/*
COPY site.conf /etc/nginx/conf.d/

COPY entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT /usr/local/bin/entrypoint
