include("Matrices.jl")
using LinearAlgebra

#Função que retorna a solução do prob. de quad. min. Min ||Ax-b||, resolvendo o sistema de acordo com opt:
#opt=1 -> Diretamente; opt=2 -> Cholesky; opt=3 -> QR
function quadMin(A,b,opt)
    if opt==1
        x=\(Symmetric(A'A),A'b) #Resolvendo direto pelo Julia (Usa fatoração LU ou algum método iterativo se esparsa)
    elseif opt==2
        L,U=cholesky(Symmetric(A'A));
        y=\(L,A'b); x=\(U,y) #Usando Cholesky e resolvendo os sistemas triangulares
    else
        Q,R=qr(A) #Achando a qr de A
        #Resolvendo o problema tomando só as n primeiras entradas de Q'*b
        b_aux=(Q'*b)[1:size(R,1)] 
        x=\(R,(b_aux))
    end
    return x
end

#Função que retorna a solução do prob. de norma mínima:
#Min 1/2 * ||x||^2 suj. a Ax=b
#Resolvendo o problema de ponto de sela associado (opt=1) ou usando a fatoração QR(opt=2)
function normaMin(A,b,opt)
    if opt==1
        #Montando a matriz do sistema de ponto de sela:
        m,n=size(A)
        sela=zeros(m+n,m+n); 
        for i=1:n
            sela[i,i]=1;
        end
        sela[1:n, (n+1):(m+n)]=A'
        sela[(n+1):(m+n), 1:n]=A
        #E o vetor do lado direito da igualdade
        b_sela=zeros(m+n); b_sela[n+1:(m+n)]=b
        #Resolvendo o sistema usando o procedimento padrão do Julia (No caso, vai ser uma fatoração LU ou algum método iterativo)
        resp=\(sela,b_sela)
        x=resp[1:n]
    else
        #Achando a fatoração QR de A^t  
        m,n=size(A); q,r=qr(A')
        y=\(r',b[1:m]); x=q[:,1:m]*y #resolvendo
    end
    return x
end