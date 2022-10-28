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
#   v1.0 25/10/2022, Mateus:
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.1.16(1)-release
#-----------------------VARIÁVEIS ----------------------------------------- #
MENSAGEM_USO="
     $(basename $0) - [OPÇÕES]

        -h - Menu de ajuda
        -v - Versão do programa
        -a - Realiza o backup em todas as empresas
        -b - Realiza o backup da Bradok
        -d - Reliza o backup da DadyIlha
        -m - Reliza o backup da Mac-id
"
CONTAS=($(cat contas.txt))
EXIST_USER=($(cat /etc/passwd | cut -d . -f 1,2 | uniq -u))


VERSAO="v1.0"
CHAVE_BRADOK=0
CHAVE_DADY=0
CHAVE_MAC=0

#-----------------------TESTES--------------------------------------------- #


#-----------------------FUNÇÕES-------------------------------------------- #

checar_usuario() {
for i in "${EXIST_USER[@]}"; do
  for j in "${CONTAS[@]}"; do
    if [ "${CONTAS[i]}" -eq "${EXIST_USER[j]}" ]; then
      echo "Valor $i encontrado"
    fi
  done
done
}

criar_usuario_mac() {
  for i in $CONTAS; do
     useradd -m                       \
             -d /home/$i'.mac-id.bkp' \
             -p '$6$5Jtt/TaEHQZoHUeW$Fdyuk3rKUO6eYQPIdnT2PYiZ.9qyXxyiPT7FLehKPZthIrUvy8Ts2.qWlkTq4ZpY0MRvKnp4mv4PVd0LFC.nW1' \;
             # Abc242526@2
  done

}

criar_usuario_dady() {
  for i in $CONTAS; do
     useradd -m                       \
             -d /home/$i'.dadyilha.bkp' \
             -p '$6$5Jtt/TaEHQZoHUeW$Fdyuk3rKUO6eYQPIdnT2PYiZ.9qyXxyiPT7FLehKPZthIrUvy8Ts2.qWlkTq4ZpY0MRvKnp4mv4PVd0LFC.nW1' \;
             # Abc242526@2
  done

}

criar_usuario_bradok() {
  for i in $CONTAS; do
     useradd -m                       \
             -d /home/$i'.bradok.bkp' \
             -p '$6$5Jtt/TaEHQZoHUeW$Fdyuk3rKUO6eYQPIdnT2PYiZ.9qyXxyiPT7FLehKPZthIrUvy8Ts2.qWlkTq4ZpY0MRvKnp4mv4PVd0LFC.nW1' \;
             # Abc242526@2
  done

}

#---------------------- EXECUÇÃO ----------------------------------------- #

checar_usuario
#------------------------------------------------------------------------- #
