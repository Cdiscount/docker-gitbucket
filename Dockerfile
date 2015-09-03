FROM debian:jessie

RUN apt-get update && \
    apt-get upgrade -q -y && \
    apt-get install -q -y --no-install-recommends openjdk-7-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -r -m -s /bin/false -d /var/lib/gitbucket/ gitbucket
RUN mkdir -p /usr/share/gitbucket/
ADD https://github.com/takezoe/gitbucket/releases/download/3.6/gitbucket.war /usr/share/gitbucket/gitbucket.war
RUN chown -R gitbucket: /var/lib/gitbucket/ /usr/share/gitbucket
RUN chmod 600 /usr/share/gitbucket/gitbucket.war

VOLUME /var/lib/gitbucket/

# Port for web page
EXPOSE 8080
# Port for SSH access to git repository (Optional)
EXPOSE 29418

USER gitbucket
CMD ["/usr/bin/java", "-jar", "/usr/share/gitbucket/gitbucket.war", "--port=8080", "--gitbucket.home=/var/lib/gitbucket/"]
