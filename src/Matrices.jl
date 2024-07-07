using LinearAlgebra

#Matriz aleatória para os testes
function randMatrix(m,n) 
    M=100; A=M*(2*rand(m,n).-1)
    return A
end

#Função que devolve um vetor com as matrizes de teste
function testMatrices(mVec)
    #Gerando as matrizes normais
    vec_matrizes=[]
    for m in mVec
        nVec=Int.([1, m/10, m/2, 9*m/10, m-1]); nVec=unique!(nVec)
        matrizes=[]
        for n in nVec  
            push!(matrizes,randMatrix(m,n))
        end
        push!(vec_matrizes,matrizes)
    end
    
    #Gerando as perturbadas para o caso em que n>1
    vec_matrizes_p=[]
    for i in eachindex(mVec)
        #Perturbando cada matriz para n>1
        matrizes_p=[]
        for j in eachindex(vec_matrizes[i])
            if j!=1
                A=deepcopy(vec_matrizes[i][j])
                n=size(A,2)
                A[:,n]=sum(A[:,k] for k=2:n)/(n-1)+10^(-5)*A[:,n]
                push!(matrizes_p,A)
            end
        end 
        push!(vec_matrizes_p,matrizes_p)
    end
    return vec_matrizes, vec_matrizes_p
end

#Função que retorna o vetor b de testes e a solução do sistema, que é um ponto aleatório
function testb(n)
    b=2*rand(n).-1
    return b
end

#Função que transpõe todas as matrizes em uma coleção devolvida por testMatrices
#Retorna esse novo vetor com as matrizes transpotas
function transposeAll(vec_matrizes)
    vec_transp=deepcopy(vec_matrizes)
    for i in eachindex(vec_transp)
        for j in eachindex(vec_transp[i])
            vec_transp[i][j]=vec_transp[i][j]'
        end
    end
    return vec_transp
end

#Função que retorna um vetor x*=A^tλ* e um vetor b=Ax* 
function testbNM(A)
    m=size(A,1);
    λ=2*rand(m).-1;
    x=A'*λ; b=A*x
    return b,x
end

#Função que dá a norma do residuo
function res(A,b,x)
    return norm(A*x-b)
end