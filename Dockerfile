FROM maven:3.5-jdk-7

MAINTAINER Raj

WORKDIR /usr/src/code

RUN git clone https://github.com/rajtotaldevops/jpetstore.git \
	&& cd jpetstore

CMD ["mvn", "clean", "package"]

VOLUME /usr/src/code/target

