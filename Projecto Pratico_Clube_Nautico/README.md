Projeto Prático - Clube Náutico

Objetivos
O objetivo deste projeto prático é criar uma aplicação informática para calcular a mensalidade a pagar pelos associados de um clube náutico. Para isso, serão implementadas classes que representam os diferentes tipos de sócios do clube e que permitam o cálculo da mensalidade de cada um.

Enunciado
O clube náutico possui quatro tipos de sócios: Sócio Jovem, Sócio Menor, Sócio Adulto e Sócio Sénior. Considera-se que um sócio é sénior se tiver mais de 60 anos e adulto se tiver mais de 18 anos. Todos os sócios são caracterizados por um identificador, nome, número de contribuinte e ano de nascimento.

Cada identificador de um sócio Menor deve ser do tipo SMenor-X, sendo X um número sequencial iniciado em 1. Cada identificador de um sócio Adulto deve ser do tipo SAdulto-Y, sendo Y um número sequencial iniciado em 1. Cada identificador de um sócio Sénior deve ser do tipo SSenior-Z, sendo Z um número sequencial iniciado em 1.

Os sócios jovens são caracterizados pelo número de aulas por semana (mínimo de 1 aula). O valor a pagar por cada aula é de 25 euros. Os sócios menores têm um desconto de 20% sobre o valor calculado.

O valor a pagar pelos sócios tem por base um valor de referência que é de 100 euros para os jovens e 150 euros para os seniores. Sobre esse valor de referência, os seniores usufruem de um desconto de 10% por cada década de idade que possuam.

Os sócios maiores de idade, poderão ser dirigentes do clube, estando, nesse caso, isentos do pagamento de mensalidade.

Deve ser criada uma classe para testar as classes implementadas e que satisfaça os seguintes requisitos:

a) Construa quatro sócios de cada tipo: Menor, Adulto e Sénior.

b) Construa um contentor de objetos, designado listaSocios, que armazena os sócios criados anteriormente.

c) Apresente uma listagem dos nomes dos encarregados de educação e, para cada um, qual a quantidade de sócios menores a seu cargo.

d) Mostre para cada sócio o valor da mensalidade a pagar. No final deve apresentar o total das mensalidades dos sócios jovens e o total das mensalidades dos sócios séniores, bem como o peso (em percentagem) que cada um destes totais possui sobre o valor total das mensalidades.
