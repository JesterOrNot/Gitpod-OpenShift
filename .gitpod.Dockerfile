FROM gitpod/workspace-full

USER gitpod

### Google Cloud ###
# not installed via repository as then 'docker-credential-gcr' is not available
ARG GCS_DIR=/opt/google-cloud-sdk
ENV PATH=$GCS_DIR/bin:$PATH
RUN sudo chown gitpod: /opt \
    && mkdir $GCS_DIR \
    && curl -fsSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-245.0.0-linux-x86_64.tar.gz \
    | tar -xzvC /opt \
    && /opt/google-cloud-sdk/install.sh --quiet --usage-reporting=false --bash-completion=true \
    --additional-components docker-credential-gcr alpha beta \
    # needed for access to our private registries
    && docker-credential-gcr configure-docker

WORKDIR $HOME/.openshift

RUN sudo chown -R gitpod $HOME/.openshift \
    && wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz" "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz" \
    && for i in *.gz; do tar xfvz $i; done \
    && mkdir bin \
    && mv kubectl oc openshift-install bin \
    && rm *.gz *.md

ENV PATH=$PATH:$HOME/.openshift/bin
