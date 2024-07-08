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

#Função que retorna o vetor b de testes para o problema de quad. Min
#Número de linhas é fixo e o que varia é o número de colunas
#Logo, vamos fixar o b para um dado m e n variando, em vez de gerar um diferente para cada possível par (m,n)
function testb(mVec)
    #Gerando os b's para o quad. minimos
    b_vec=[2*rand(m).-1 for m in mVec]
    return b_vec
end

#Função que retorna o vetor com os x*=A^tλ* e um vetor b=Ax* -> Para o problema de norma mínima
#Nesse caso, pelo exemplo, o número de linhas vai variar em função de um m fixo
#Vamos gerar um b diferente para cada par (m,n)
function testbNM(vec_matrizes)
    #Gerando os x* e b
    x_vec=[]; b_vec=[]
    for i in eachindex(vec_matrizes)
        xs=[]; bs=[]
        for j in eachindex(vec_matrizes[i])
            A=vec_matrizes[i][j]; m=size(A,1)  
            push!(xs,A'*(2*rand(m).-1))
            push!(bs,A*xs[j])
        end
        push!(x_vec,xs)
        push!(b_vec,bs)
    end
    return b_vec, x_vec
end

#Função que dá a norma do residuo
function res(A,b,x)
    return norm(A*x-b)
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