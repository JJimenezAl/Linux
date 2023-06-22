#! \bin\bash

user=$(whoami)

if [[ $user = "root" ]]
then
	echo "Elija una opcion"
	echo "1 - Comprobar fortaleza de una contraseña"
	echo "2 - Realizar una ataque de fuerza bruta"
	echo "3 - Renovar contraseña"
	echo "4 - Cambiar fecha de expidación de la contraseña de un usuario"
	echo
	read opcion
	echo

#Opcion 1

	if [[ $opcion = 1 ]]
	then
		comprobacion(){
		echo "Dime la clave"
		read clave

		declare -i long=${#clave} 
		 
		declare -i min=4

		declare -i rec=6

		num=[0-9]

		punt=0

		if [[ $long > $min ]]
			then

			if [[ $clave =~ [A-Z]  ]]
			then
				echo "Tiene mayúsculas +20% "
				let punt+=20
			fi

		  	if  [[ $clave =~ $num[a-zA-Z]|[a-zA-Z]$num ]]
			then
		  		echo "Contraseña contiene números y letras + 60%"
		  		let punt+=60

			elif  [[ $clave != *$num* ]]
			then
		  		echo "Contraseña contiene solamente letras + 30%"
		  		let punt+=30

		  	elif [[ $clave != *[a-zA-Z]* ]]
		  	then
		  		echo "Contraseña contiene solamente números + 30%"
		  		let punt+=30
			fi

			if [[ $long > $rec ]]
			then
				echo "Es mayor de 8 + 20% "
				let punt+=20
			fi

		else 
			echo $long,"La contraseña es demadiado corta"
		fi

		if [[ $punt > 50 ]]
		then
			echo "La contraseña es válida, porque posee un porcertaje de seguridad del" $punt"%"
			ok=1
			exit
		else
			echo "La contraseña no es válida, porcentaje de seguridad demasiado bajo" $punt"%"
			echo "¿Desea probrar de nuevo?"
			read result
			if [ $result == 'si' ]
			then
				comprobacion
			else
				ok=0 
				exit
			fi
		fi
		}
		comprobacion
	fi

#Opcion 2

	if [[ $opcion = 2 ]]
	then
		#apt-get update > /dev/null && apt-get install -y john > /dev/null
		echo
		echo "John está instalado"
		ataque(){
			echo "¿Desea comenzar el ataque?"
			read res
				if [ $res == 'si' ]
				then 
					unshadow /etc/passwd /etc/shadow > ~/fichero
					echo "Comienza el ataque, por favor espere..."
					echo
					john ~/fichero > /dev/null
					echo
					echo "Ataque finalizado"
					echo
					resultado=$(john --show ~/fichero)
					echo $resultado > ~/resultado.txt
					echo "User    Clave"
					cut -d: -f1,2 ~/resultado.txt | tr ':' '\t'
					echo
					#Obtengo el ususario que debe cambiar la clave
					usuario=$(cut -d: -f1,1 ~/resultado.txt)
					echo "El usuario "$usuario" tiene que cambiar la clave"
				else
					echo "Ataque cancelado"			
				fi
		}
		ataque
		echo "¿Desea cambiar la clave?"
		read result

		if [ $result = 'si' ]
		then
			echo "No me fio de ti asi que vamos a ver su fortaleza"
			comprobacion # Fallo no se encontró la orden // bash: [: =: se esperaba un operador unario ¿Hay que ejecutar la funcion?
			if [[ $ok = 1 ]]
			then
				echo $clave
				passwd $usuario
				echo "Ahora vamos a realizar un nuevo ataque"
				echo "Si tras 5 minutos no optenemos la clave, es una clave válida"
			else
				echo "La clave no cumple con los requisitos mínimos"
				exit
			fi
		else
			echo "Hasta otra mendrugo"
			exit
		fi
	fi

#Opcion 3

	if [ $opcion = 3 ]
	then
		existe(){
		echo "Teclea el usuario"
		read usuariocambio
		unshadow /etc/passwd /etc/shadow > ~/fichero
		#Busqueda
	 	find ~/fichero -type f | xargs grep $usuariocambio > /dev/null
	 	}
	 	existe
	 	if [ $? -eq 0 ] 
	 	then
			passwd $usuariocambio
		else
			echo "El usuario "$usuariocambio" no se encuentra disponible en el sistema"
		fi
		
	fi

#Opcion 4
	
	if [ $opcion = 4 ]
	then
		existe
		if [ $? -eq 0 ] # Comprobar porque no "salta en condiciones" cuando no encuntra el ususario.
	 	then
	 		echo "¿Cada cuantos dias desea cambiar la contraseña?"
	 		read dias
			chage -M $dias $usuariocambio
			echo 
			chage -l $usuariocambio
		fi
	fi


#--------------------------------------------FINAL------------------------------------------------------------------
else
	echo "Debes de ser root para poder ejecutar el script"
fi