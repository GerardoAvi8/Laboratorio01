/*
* pre-Laboratorio01.asm
*
* Created: 03/02/2025 10:55:24
* Author : Gerardo Avila
* Descripción: Contador binario de 4 bits
*/

//Encabezado (Definición de registros, variables y constantes)
.include "M328PDEF.inc"

.cseg
.org	0x0000

//Configuracion de la pila
LDI		R16, LOW(RAMEND)
OUT		SPL, R16			//Cargar 0xff a SPL
LDI		R16, HIGH(RAMEND)
OUT		SPH, R16			//CARGAR 0x00 a SPL

//Configuración de MCU
SETUP:
	//Configuracion para desabilitar bits de serial
	LDI		R16, 0x00		//Cargamos 0 al registro
	STS		UCSR0B, R16		//Colocamos el valor de R16 al registro que controla comserial
	
	//Configurar puertos (DDRx, PORTX, PINx)
	//Configurar puerto D como salida
	LDI		R16, 0xFF
	OUT		DDRD, R16		//Configuramos el puerto D como salida
	LDI		R16, 0b00000000
	OUT		PORTD, R16		//Todos los bits comienzan apagados
	//Configurar puerto C como salida
	LDI		R16, 0xFF
	OUT		DDRC, R16
	LDI		R16, 0b00000000
	OUT		PORTC, R16	
	//Puerto B como entrada con pull-ups habilitados
	LDI		R16, 0x00
	OUT		DDRB, R16		//Configuración de B como entrada
	LDI		R16, 0b00011111
	OUT		PORTB, R16		//Habilitamos dos ultimos bits con pull-ups

	LDI		R17, 0b00011111	//Guardamos en un registro el estado inicial de botones

//Loop principal
MAIN:
	IN		R16, PINB		//Leemos el puerto B
	CP		R17, R16		//Comparamos valor guardado con valor actual
	BREQ	MAIN			//Si son iguales regresamos al inicio

	CALL	WAIT			//Esperamos 0.5segundos para confirmar lectura

	IN		R16, PINB		//Leemos el puerto B
	CP		R17, R16		//Comparamos valor guardado con valor actual
	BREQ	MAIN			//Si son iguales regresamos al incio

	MOV		R17, R16		//Si no son iguales, guardamos el nuevo valor en R17

	SBRS	R16, 0			//Revisar si el bit en registro es 1, es decir, si el botón está presionado o no
	CALL	INCREMENTO1		//Si el valor es 1, entonces salta la siguiente linea, de ser caso contrario, incrementa PORTD

	SBRS	R16, 1			//Revisar si el bit en registro es 1, es decir, si el botón está presionado o no
	CALL	DECREMENTO1		//Si el valor es 1, entonces salta la siguiente linea, de ser caso contrario, decrementa PORTD

	SBRS	R16, 2			//Revisar si el bit en registro es 1, es decir, si el botón está presionado o no
	CALL	INCREMENTO2		//Si el valor es 1, entonces salta la siguente linea, de ser caso contrario, incrementa PORTD

	SBRS	R16, 3			//Revisar si el bit en registro es 1, es decir, si el botón está presionado o no
	CALL	DECREMENTO2		//Si el valor es 1, entonces slata la siguiente linea, de ser caso contrario, decrementa PORTD

	SBRS	R16, 4			//Revisamos si el boton de suma fue presionado o no
	CALL	SUMA			//Ir a subrutina SUMA

	RJMP	MAIN			//Regresar al incio


//Sub-rutinas
WAIT:
	LDI		R18, 0			//Empieza la cuenta en 0
WAIT1:
	INC		R18				//Empieza el primer contador
	CPI		R18, 0			//Verificamos que la cuenta terminó
	BRNE	WAIT1			//Si la cuenta no ha terminado que siga contando
	LDI		R18, 0			//De haber terminado, volver a cargar 0
WAIT2:
	INC		R18				
	CPI		R18, 0			
	BRNE	WAIT2
	LDI		R18, 0
WAIT3:
	INC		R18				
	CPI		R18, 0			
	BRNE	WAIT3			
	LDI		R18, 0
WAIT4:
	INC		R18				
	CPI		R18, 0			
	BRNE	WAIT4			
	LDI		R18, 0
WAIT5:
	INC		R18				
	CPI		R18, 0			
	BRNE	WAIT5			
	LDI		R18, 0
WAIT6:
	INC		R18				
	CPI		R18, 0			
	BRNE	WAIT6			
	LDI		R18, 0
WAIT7:
	INC		R18				
	CPI		R18, 0			
	BRNE	WAIT7			
	LDI		R18, 0
WAIT8:
	INC		R18				
	CPI		R18, 0			
	BRNE	WAIT8			
	LDI		R18, 0
WAIT9:
	INC		R18				
	CPI		R18, 0			
	BRNE	WAIT9			
	LDI		R18, 0
WAIT10:
	INC		R18				
	CPI		R18, 0			
	BRNE	WAIT10			
	RET						//Regresamos a MAIN

INCREMENTO1:
	INC		R19				//Incremento del registro
	ANDI	R19, 0x0F
	IN		R22, PORTD
	ANDI	R22, 0xF0
	OR		R22, R19
	OUT		PORTD, R22
	RET						//Volvemos a MAIN

DECREMENTO1:
	DEC		R19				//Decremento del registro
	ANDI	R19, 0x0F
	IN		R22, PORTD
	ANDI	R22, 0xF0
	OR		R22, R19
	OUT		PORTD, R22
	RET						//Volvemos a MAIN
	
INCREMENTO2:
	INC		R20				//Incremento del registro
	ANDI	R20, 0x0F		//Limpiamos los bits altos para que no afecten en el incremento
	MOV		R21, R20		//Guardamos el valor en otro registro para no manipular el original
	LSL		R21				//Corremos los bits del registro 20 un espacio a la izquierda
	LSL		R21
	LSL		R21
	LSL		R21
	IN		R22, PORTD		//Leeos el puerto D y los guardamos en R22
	ANDI	R22, 0x0F		//Limpiamos los bits altos para que no afecten y puedan usarse
	OR		R22, R21		//Movemos el valor de R21 a R22
	OUT		PORTD, R22		//Mostramos el valor de R22 en el puerto D
	RET	
	
DECREMENTO2:
	DEC		R20				//Decremento del registro
	ANDI	R20, 0x0F		//Limpiamos los bits altos para que no afecten en el decremento
	MOV		R21, R20		//Guardamos el valor en otro registro para no manipular el original
	LSL		R21				//Corremos los bits del registro 20 un espacio a la izquierda
	LSL		R21	
	LSL		R21
	LSL		R21
	IN		R22, PORTD		//Leemos el puerto D y lo guardamos en R22
	ANDI	R22, 0x0F		//Limpiamos los bits altos para que no afecten y puedan usarse
	OR		R22, R21		//Movemos el valor de R21 a R22
	OUT		PORTD, R22		//Mostramos el valor de R22 en el puerto D
	RET	
	
SUMA:
	MOV		R23, R19		//Guardar ese valor en otro registro para no manipular el original
	ADD		R23, R20		//Sumar registros y valores

	ANDI	R23, 0x1F		//Colocar un límite de 5 bits en el registro 23
	IN		R24, PORTC		//Leer el valor que tiene el puerto C y guardarlo en el registro 24
	ANDI	R24, 0xE0		//Agregar un limite, limpiando los bits altos para no afectar bits que usaremos en la suma
	OR		R24, R23		//Colocar el valor de R23 en R24
	OUT		PORTC, R24		//Mostrar en el puertoC el valor de R24

	SBRC	R23, 4			//Revisar si el bit 4 del registro R23 esta apagado
	SBI		PORTC, 4		//Encender el 4to bit del puertoC
	SBRS	R23, 4			//Revisar si el bit 4 del registro R23 esta encendido
	CBI		PORTC, 4		//Apagar el 4to bit del puertoC

	RET