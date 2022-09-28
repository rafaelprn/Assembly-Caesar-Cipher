.data
	perg1: .asciiz "Deseja criptografar ou descriptografar? (1 ou -1) "
	perg2: .asciiz "Qual a ordem da cifra? "
	perg3: .asciiz "Qual a palavra a ser criptografa? "
	palavra: .space 101 #palavra a ser critografada, 101 por conta do /0 no final
	ordemCifra: .word #ordem da cifra
	cifraOuDescifra: .word #define se vai ser cifra para frente ou para tras
.text
input:
	#imprimir pergunta pro usuario (Qual a palavra a ser criptografa?)
	li $v0, 4
	la $a0, perg3
	syscall
	#leitura da palavra a ser criptografa
	li $v0, 8 #le string: scanf
	la $a0, palavra #vai carregar a variavel palavra (LoadAdress)
	la $a1, 101 #informamos em a1 o tamanho que queremos ler, damos loadadress
	syscall #execute

	#imprimir pergunta da ordem cifra (Qual a ordem da cifra?)
	li $v0, 4
	la $a0, perg2
	syscall
	#leitura da ordem
	li $v0, 5 #le int: scanf
	syscall #execute
	move $t2, $v0 #bota a ordem da cifra no registrador t2
	
	#imprimir pergunta cifraOuDescifra
	li $v0, 4
	la $a0, perg1
	syscall
	#leitura da cifraOuDescifra
	li $v0, 5 #le int: scanf
	syscall #execute
	mul $t2, $t2, $v0 #faz o cript ou descript, caso seja 1 ou -1, tornando a ordem pos. ou neg.
	
	add $s0, $s0, $zero #contador
	jal functCript #chama a funcao
	
	#saida da string já criptografada, saida do programa
	li $v0, 4
	la, $a0, palavra
	syscall
	
	#fim do programa
	li $v0, 10
	syscall
	
functCript: #comeco da funcao base
	#ASCII 65-90 e 97-122
	addi $s1, $zero, 101 #guardando 101 em s1, para comparação
	beq $s0, $s1, functJrRa #for (int i = 0;i <= 101; i++)
	#{
	la $t1, palavra #carrega palavra em t1
	add $t1, $t1, $s0 #t1 + contador, percorre a string
	lb $s2, 0($t1) #carrega o byte atual em s2
	
	slti $t3, $s2, 33 #verififca se o codigo do char é menor que 33
	sgt $t4, $s2, 126 #verifica se o codigo do char é maior que 126
	or $t5, $t3, $t4 #caso um dos dois tenha dado verdadeiro, guarda verdadeiro (1) em t5
	addi $t3, $zero, 1 #adicionando o valor 1 ao registrador t3, apenas para comparação
	beq $t5, $t3, functIgnorar #caso tenha dado verdadeiro em t5, chama functignorar
	
	#caso após a criptografia, o caractere atual fique fora do limite válido
	addi $t5, $zero, 1 #armazena verdadeiro p comparação em t5
	add $s2, $s2, $t2 #realiza a criptografia, anda com o char
	slti $t3, $s2, 33 #verificação se esta menor que 33
	beq $t3, $t5, functAdd #caso seja menor, chama functAdd
	sgt $t3, $s2, 126 #verificação se é maior que 126
	beq $t3, $t5, functSub #caso seja maior, chama functSub
	
	sb $s2, 0($t1) #guardando o char criptografado
	addi $s0, $s0, 1 #contador +1
	j functCript #volta para functCript
	#}

functAdd:
	addi $s2, $s2, 94
	#verficação caso o usuário insira um fator de criptografia menor que -94
	slti $t7, $s2, 33
	bne $t7, $zero, functAdd
	
	sb $s2, 0($t1) #armazena
	addi $s0, $s0, 1 #contador +1
	j functCript
	
functSub:
	addi $s2, $s2, -94 
	#verficação caso o usuário insira um fator de criptografia maior que 94
	sgt $t7, $s2, 126
	bne $t7, $zero, functSub
	
	sb $s2, 0($t1) #armazena
	addi $s0, $s0, 1 #contador +1
	j functCript

functJrRa:
	#retorna para o ponto de execucao do codigo
	jr $ra #FIM DO LOOP
	
functIgnorar: #nao faz nada com o byte atual
	addi $s0, $s0, 1 #contador +1
	j functCript
