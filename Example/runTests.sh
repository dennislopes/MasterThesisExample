#!/usr/bin/env bash

readonly NOCOLOR="\033[0m"
readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[1;33m"
readonly BLUE="\033[0;34m"       
readonly PURPLE="\033[0;35m"       
readonly CYAN="\033[0;36m"         

export PROJECT_ROOT_DIR="/PPgSI/workdir"
export RESULTS_DIR="/PPgSI/results"
export PATH="$PATH:/PPgSI/defects4j/framework/bin"
export PROJECT_DIR="$PROJECT_ROOT_DIR/Example"
export BADUA_AGENT="/PPgSI/ba-dua/ba-dua-agent-rt/target/ba-dua-agent-rt-0.4.1-SNAPSHOT-all.jar"
export BADUA_JAR="/PPgSI/ba-dua/ba-dua-cli/target/ba-dua-cli-0.4.1-SNAPSHOT-all.jar"
export JAGUAR_JAR="/PPgSI/jaguar-df/target/jaguar-df-0.1-SNAPSHOT-all.jar"
export JAGUAR_MAIN_CLASS="br.usp.each.saeg.jaguardf.cli.JaguarRunner"
export LOG_LEVEL="TRACE"
export OUTPUT_DIR="report/df"
export JUNIT_JAR="/PPgSI/df-experiments/lib/junit-4.13.2.jar"
export HAMCREST="/PPgSI/df-experiments/lib/hamcrest-core-1.3.jar"
export JUNIT_CLASS="org.junit.runner.JUnitCore"
export CLASSES_DIR="/PPgSI/workdir/Example"

export PARAMETER="-Dbadua.experimental.exception_handler=true"
export PARAMETER="-Dbadua.experimental.ModifiedSystemClassRuntime=true"

echo -e "\n${YELLOW} Carregando o diretorio do projeto ${NOCOLOR}"
cd $PROJECT_DIR

echo -e "${GREEN} compilando classes${NOCOLOR}"
javac -cp lib/junit-4.13.2.jar:. src/br/university/sfl/*.java
echo -e "${GREEN} compilando testes${NOCOLOR}"
javac -cp lib/junit-4.13.2.jar:. src/br/university/sfl/*.java

echo -e "\n${BLUE} Testando os testes com o jUnit ${NOCOLOR}"
java -cp .:lib/junit.jar:src org.junit.runner.JUnitCore br.university.sfl.MaxTest

echo -e "\n${RED} Executando os testes com a Ba-dua${NOCOLOR}"
java -Xmx1536m -javaagent:$BADUA_AGENT \
		$PARAMETER  \
			-cp .:lib/junit.jar:src org.junit.runner.JUnitCore \
			$JUNIT_CLASS br.university.sfl.MaxTest  | tee $PROJECT_DIR/ba-dua.out

echo -e "\n${RED} Gerando relatorio da Ba-dua ${NOCOLOR}"
java -jar $BADUA_JAR report \
	-show-classes \
	-input coverage.ser \
	-classes $CLASSES_DIR \
	-xml $PROJECT_DIR/ba-dua.xml

echo -e "\n${RED} Gerando relatorio da Ba-dua (pretty print) ${NOCOLOR}"
xmllint --format $PROJECT_DIR/ba-dua.xml --output $PROJECT_DIR/ba-dua.xml
#rm coverage.ser

echo -e "\n${GREEN} Executando a jaguar${NOCOLOR}"
(time java -Xmx1536m -javaagent:$BADUA_AGENT \
    $PARAMETER  \
    -cp .:lib/junit.jar:src:$JAGUAR_JAR:$BADUA_AGENT \
	$JAGUAR_MAIN_CLASS \
	--projectDir $PROJECT_DIR \
	--classesDir . \
	--testsDir  . \
	--tests $PROJECT_DIR/tests.all \
	--logLevel "INFO") | tee $PROJECT_DIR/jaguar.out

echo -e "\n${GREEN} Gerando relatorio da Ba-dua ${NOCOLOR}"
java -jar $BADUA_JAR report \
	-show-classes \
	-input coverage.ser \
	-classes $CLASSES_DIR \
	-xml $PROJECT_DIR/ba-dua_jaguar.xml
	
echo -e "\n${GREEN} Gerando relatorio da Ba-dua (pretty print) ${NOCOLOR}"
xmllint --format $PROJECT_DIR/ba-dua_jaguar.xml --output $PROJECT_DIR/ba-dua_jaguar.xml



