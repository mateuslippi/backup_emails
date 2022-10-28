#!/usr/bin/env bash
#
# syncAccountsAll.sh - Verifica a última cotação do Bitcoin
#
# Autor:      Mateus Lippi
# Manutenção: Mateus Lippi
#
# ------------------------------------------------------------------------ #
#  Este programa irá realizar o backup de e-mails que temos na empresa
# de acordo com o parâmetro passado pelo usuário.
#
#  Exemplos:
#      $ ./syncAccountsAll.sh -a
#      Fará o backup dos emails da empresa.
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 28/10/2022, Mateus:
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.1.16(1)-release
#-----------------------VARIÁVEIS ----------------------------------------- #
MENSAGEM_USO="
     $(basename $0) - [OPÇÕES]

        -h - Menu de ajuda
        -v - Versão do programa
        -a - Realiza o backup em todas as empresas (Futuro)
        -b - Realiza o backup da Bradok
        -d - Realiza o backup da DadyIlha
        -m - Realiza o backup da Mac-id

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
fi
USERNAME=$(cat /tmp/userlist | tr 'A-Z'  'a-z')
PASSWORD='6$5Jtt/TaEHQZoHUeW$Fdyuk3rKUO6eYQPIdnT2PYiZ.9qyXxyiPT7FLehKPZthIrUvy8Ts2.qWlkTq4ZpY0MRvKnp4mv4PVd0LFC.nW1'


VERSAO="v1.0"
CHAVE_BRADOK=0
CHAVE_DADY=0
CHAVE_MAC=0
CHAVE_ALL=0s

#-----------------------TESTES--------------------------------------------- #

#-----------------------FUNÇÕES-------------------------------------------- #

criar_usuario_mac() {
  for i in $USERNAME; do
     useradd -m                         \
             -d /home/$i'.mac-id.bkp'   \
             -p $PASSWORD               \;

  done

}

criar_usuario_dady() {
  for i in $USERNAME; do
     useradd -m                         \
             -d /home/$i'.dadyilha.bkp' \
             -p $PASSWORD               \;
  done

}

criar_usuario_bradok() {
  for i in $USERNAME; do
     useradd -m                        \
             -d /home/$i'.bradok.bkp'  \
             -p $PASSWORD              \;
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
                   --nossl2                               \;
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
                   --nossl2                               \;
  done < "$USERFILE"
}
email_mac() {
  while read p; do
          imapsync --host1 'sh-pro32.hostgator.com.br'    \
                   --user1 $p'@mac-id.com.br'             \
                   --password1 'Excluido@2' --ssl1 --sslargs1 "SSL_verify_mode=1"  \
                   --host2 'localhost'                    \
                   --user2 $p'.mac-id.bkp'                \
                   --password2 'Abc242526@2'              \
                   --nossl2                               \;
  done < "$USERFILE"
}

#---------------------- EXECUÇÃO ----------------------------------------- #

case $1 in
  -h) echo "$MENSAGEM_USO" && exit 0                   ;;
  -v) echo "$VERSAO" && exit 0                         ;;
  -d) CHAVE_DADY=1                                     ;;
  -b) CHAVE_BRADOK=1                                   ;;
  -c) CHAVE_MAC=1                                      ;;
  -a) CHAVE_ALL=1                                      ;;
   *) echo "Seleciona uma opção válida. Consulte o -h" ;;
esac

[ $CHAVE_DADY -eq 1 ] && email_dady
[ $CHAVE_BRADOK -eq 1 ] && email_bradok
[ $CHAVE_MAC -eq 1 ] && email_mac

# PROJETO MULTITHREADING:
# if [ $CHAVE_ALL -eq 1 ]; then
#   email_dady
#   email_mac
#   email_bradok
# fi

#------------------------------------------------------------------------- #
