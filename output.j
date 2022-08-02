.class public test
.super java/lang/Object

.field static private message Ljava/lang/String;
.method public <init>()V
aload_0
invokenonvirtual java/lang/Object/<init>()V
return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 100
.limit stack 100
.line 1
L_0:
ldc 0
istore 1
L_1:
ldc 0
istore 2
L_2:
iconst_0
istore 3
L_3:
iconst_0
istore 4
L_4:
iconst_0
istore 5
L_5:
ldc 5
istore 3
L_6:
ldc "Digite um numero: \n"
putstatic      test/message Ljava/lang/String;
getstatic      java/lang/System/out Ljava/io/PrintStream;
getstatic      test/message Ljava/lang/String;
invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V
L_7:
ldc "5\n"
putstatic      test/message Ljava/lang/String;
getstatic      java/lang/System/out Ljava/io/PrintStream;
getstatic      test/message Ljava/lang/String;
invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V
L_8:
L_9:
iload 5
ldc 10
if_icmplt L_10
goto L_12
L_10:
iload 5
ldc 1
iadd
istore 5
L_11:
iload 3
ldc 1
iadd
istore 3
goto L_9
L_12:
ldc "Incrementado algumas vezes a fica"
putstatic      test/message Ljava/lang/String;
getstatic      java/lang/System/out Ljava/io/PrintStream;
getstatic      test/message Ljava/lang/String;
invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V
L_13:
ldc 1
istore 4
L_14:
iload 4
ldc 10
if_icmplt L_16
goto L_17
L_15:
iload 4
ldc 1
iadd
istore 4
goto L_14
L_16:
ldc "."
putstatic      test/message Ljava/lang/String;
getstatic      java/lang/System/out Ljava/io/PrintStream;
getstatic      test/message Ljava/lang/String;
invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V
goto L_15
L_17:
ldc "\n"
putstatic      test/message Ljava/lang/String;
getstatic      java/lang/System/out Ljava/io/PrintStream;
getstatic      test/message Ljava/lang/String;
invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V
L_18:
iload 3
ldc 15
if_icmpeq L_19
goto L_20
L_19:
ldc "A=15\n"
putstatic      test/message Ljava/lang/String;
getstatic      java/lang/System/out Ljava/io/PrintStream;
getstatic      test/message Ljava/lang/String;
invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V
goto L_20
L_20:
iload 3
ldc 18
if_icmpeq L_22
goto L_21
L_21:
iload 3
ldc 20
if_icmpeq L_22
goto L_23
L_22:
ldc "A igual a 18 ou 20\n"
putstatic      test/message Ljava/lang/String;
getstatic      java/lang/System/out Ljava/io/PrintStream;
getstatic      test/message Ljava/lang/String;
invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V
goto L_23
L_23:
iload 5
ldc 100
if_icmpeq L_24
goto L_25
L_24:
ldc "Decorando o texto...\n"
putstatic      test/message Ljava/lang/String;
getstatic      java/lang/System/out Ljava/io/PrintStream;
getstatic      test/message Ljava/lang/String;
invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V
goto L_26
L_25:
ldc "OK!\n"
putstatic      test/message Ljava/lang/String;
getstatic      java/lang/System/out Ljava/io/PrintStream;
getstatic      test/message Ljava/lang/String;
invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V
L_26:
return
.end method
