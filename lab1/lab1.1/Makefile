cal:
	yacc calculate.y
	gcc y.tab.c -o cal
	./cal
post:
	yacc post.y
	gcc y.tab.c -o post
	./post

clean:
	rm y.tab.c 