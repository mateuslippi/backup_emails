#!/usr/bin/env bash
#
# emails.sh - Automatização Backup de e-mails.
#
# Autor:      Mateus Lippi
# Manutenção: Mateus Lippi
#
# ------------------------------------------------------------------------ #
#  Este programa irá realizar a criação de usuários, deletamento,
# e o backup de e-mails que temos na empresa de acordo com os parâmetros
# passados pelos usuários.
#
#  Exemplos:
#      $ ./emails.sh -a
#      Fará o backup dos emails da empresa.
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 29/10/2022, Mateus:
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.1.16(1)-release
#-----------------------VARIÁVEIS ----------------------------------------- #
MENSAGEM_USO="
     $(basename $0) - [OPÇÕES]

        -h - Menu de ajuda
        -v - Versão do programa

        -B - Realiza o backup da Bradok
        -D - Realiza o backup da DadyIlha
        -M - Realiza o backup da Mac-id
        -A - Realiza o backup em todas as empresas (Futuro)

        -b realiza a criação de usuário para Bradok
        -d realiza a criação de usuário para DadyIlha
        -m realiza a criação de usuário para Mac-id
        -a realiza a criação de usuário para todas as empresas (Futuro)



        observação: É necessário inserir o nome dos usuários
        em linhas separadas no diretório "/tmp/userlist"\


"
ARQUIVOOK=0
USERFILE=/tmp/userlist

#Verificar a existência do arquivo que contém os usuários e cria o arquivo caso não exista.
if [[ -f "$USERFILE" ]]; then
  ARQUIVOOK=1
else
  touch $USERFILE
  echo "
---------------------------------------------------------------------------------------
O arquivo $USERFILE foi criado. Por favor, insira os usuários em linhas separadas
dentro deste arquivo. Consulte -h para verficar as opções de comandos disponíveis.
---------------------------------------------------------------------------------------
  "
 exit 0
fi

USERNAME=$(cat /tmp/userlist | tr 'A-Z'  'a-z')
PASSWORD='$6$5Jtt/TaEHQZoHUeW$Fdyuk3rKUO6eYQPIdnT2PYiZ.9qyXxyiPT7FLehKPZthIrUvy8Ts2.qWlkTq4ZpY0MRvKnp4mv4PVd0LFC.nW1'

VERSAO="v1.0"
USU_BRADOK=0
USU_DADY=0
USU_MAC=0
USU_ALL=0
BACKUP_BRADOK=0
BACKUP_DADY=0
BACKUP_MAC=0
BACKUP_ALL=0

#-----------------------TESTES--------------------------------------------- #

#-----------------------FUNÇÕES-------------------------------------------- #

criar_usuario_mac() {
  for i in $USERNAME; do
     useradd -m                               \
             -d /home/$i'.mac-id.bkp'         \
             -p $PASSWORD $i'.mac-id.bkp' > /dev/null 2>&1
     if [ $? != 0 ]; then
       echo "Usuário $i'.mac-id.bkp' já existe."
     else
       echo "Usuário $i'.mac-id.bkp' criado com sucesso!"
     fi
  done
}

criar_usuario_dady() {
  for i in $USERNAME; do
     useradd -m                              \
             -d /home/$i'.dadyilha.bkp'      \
             -p $PASSWORD $i'.dadyilha.bkp' > /dev/null 2>&1
    if [ $? != 0 ]; then
      echo "Usuário $i'.dadyilha.bkp' já existe."
    else
      echo "Usuário $i'.dadyilha.bkp' criado com sucesso!"
    fi
  done
}

criar_usuario_bradok() {
  for i in $USERNAME; do
     useradd -m                             \
             -d /home/$i'.bradok.bkp'       \
             -p $PASSWORD $i'.bradok.bkp' > /dev/null 2>&1
     if [ $? != 0 ]; then
       echo "Usuário $i'.bradok.bkp' já existe."
     else
       echo "Usuário $i'.bradok.bkp' criado com sucesso!"
     fi
  done
}

email_dady() {
  while read p; do
          imapsync --host1 'imap.umbler.com'              \
                   --user1 $p'@dadyilha.com.br'           \
                   --password1 'Excluido@2' --ssl1 --sslargs1 "SSL_verify_mode=1"  \
                   --host2 'localhost'                    \
                   --user2 $p'.dadyilha.bkp'              \
                   --password2 'Abc242526@2'              \
                   --nossl2                               \

  echo "Sincronização/Backup de e-mails do usuário $p@dadyilha.com.br com o servidor local concuída."
  > $p'.mac-id'.log 2>&1 ;
  done < "$USERFILE"
}

email_bradok() {
  while read p; do
          imapsync --host1 'sh-pro32.hostgator.com.br'    \
                   --user1 $p'@bradok.com.br'             \
                   --password1 'Excluido@2' --ssl1 --sslargs1 "SSL_verify_mode=1"  \
                   --host2 'localhost'                    \
                   --user2 $p'.bradok.bkp'                \
                   --password2 'Abc242526@2'              \
                   --nossl2                               \

  echo "Sincronização/Backup de e-mails do usuário $p@bradok.com.br com o servidor local concuída."
  > $p'.mac-id'.log 2>&1 ;
  done <"$USERFILE"
}

email_mac() {
  while read p; do
          imapsync --host1 'sh-pro32.hostgator.com.br'    \
                   --user1 $p'@mac-id.com.br'             \
                   --password1 'Excluido@2' --ssl1 --sslargs1 "SSL_verify_mode=1"  \
                   --host2 'localhost'                    \
                   --user2 $p'.mac-id.bkp'                \
                   --password2 'Abc242526@2'              \
                   --nossl2                               \

  echo "Sincronização/Backup de e-mails do usuário $p@mac-id.com.br com o servidor local concuída."
  > $p'.mac-id'.log 2>&1 ;
  done <"$USERFILE"
}

#---------------------- EXECUÇÃO ----------------------------------------- #
case $1 in
  -h) echo "$MENSAGEM_USO" && exit 0                              ;;
  -v) echo "$VERSAO" && exit 0                                    ;;
  -b) USU_BRADOK=1                                                ;;
  -B) BACKUP_BRADOK=1                                             ;;
  -d) USU_DADY=1                                                  ;;
  -D) BACKUP_DADY=1                                               ;;
  -m) USU_MAC=1                                                   ;;
  -M) BACKUP_MAC=1                                                ;;
  -a) USU_ALL=1                                                   ;;
  -A) BACKUP_ALL=1                                                ;;
   *) echo "Por favor, insira um parâmetro de ação correto. (Consulte -h)" ;;
esac

#Execução da criação de usuários respectivos à cada empresa.
[ $USU_DADY -eq 1 ] && criar_usuario_dady && exit 0
[ $USU_BRADOK -eq 1 ] && criar_usuario_bradok && exit 0
[ $USU_MAC -eq 1 ] && criar_usuario_mac && exit 0

if [ $USU_ALL -eq 1 ]; then
  criar_usuario_bradok &
  criar_usuario_dady &
  criar_usuario_mac &
  wait
fi

#Execução da sincronia(backup) de e-mails respectivos à cada empresa.
[ $BACKUP_DADY -eq 1 ] && email_dady && exit 0
[ $BACKUP_BRADOK -eq 1 ] && email_bradok && exit 0
[ $BACKUP_MAC -eq 1 ] && email_mac && exit 0

if [ $BACKUP_ALL -eq 1 ]; then
  #Atente-se, é criado um processo filho para cada um dos 3 abaixo, simultaneamtente.
  #Tome cuidado pois matar o processo pai, não cancelará os processos filhos.
  email_bradok &
  email_dady &
  email_mac &
  wait
fi

#------------------------------------------------------------------------- #
