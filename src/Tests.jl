include("Matrices.jl")
include("Methods.jl")
#Função para executar os testes planejados para o problema de quadrados minimos a partir de um vetor com as matrizes
#Retorna um vetor de tabelas cuja primeira coluna são os valores de n
#Recebe o vetor das matrizes e o vetor dos b's
function runQM(vec_matrizes,b_vec)
    result_axb = []  #Lista para armazenar as matrizes de norma de resíduo
    result_tempo = []  #Lista para armazenar as matrizes de tempo
    for i in eachindex(vec_matrizes)  #Iterando pelo vetor externo
        result_x = zeros(length(vec_matrizes[i]), 4)  #Matriz para ||Ax-b||
        result_t = zeros(length(vec_matrizes[i]), 4)  #Matriz para tempo
        b = b_vec[i]  #Vetor de testes, do sistema Ax=b
        for j in eachindex(vec_matrizes[i])  #Iterando pelas matrizes internas
            n=size(vec_matrizes[i][j],2)  #Dimensões da matriz
            r = zeros(3); t=zeros(3)  #Vetor para norma de resíduo e vetor para Tempo
            for k in 1:3  #Iterando para cada método em estudo e guardando tempo/residuo
                t[k] = @elapsed r[k] = res(vec_matrizes[i][j], b, quadMin(vec_matrizes[i][j], b, k))
            end
            #Preenchendo
            result_x[j, 1]=n; result_t[j, 1]=n
            result_x[j, 2:end] = r  #Armazenando os valores de ||Ax-b||
            result_t[j, 2:end] = t  #Armazenando os valores de tempo
        end
        push!(result_axb, result_x)  #Adicionando a matriz de ||Ax-b|| à lista
        push!(result_tempo, result_t)  #Adicionando a matriz de tempo à lista
    end
    return result_axb, result_tempo  # Retornando as listas de matrizes
end

#Função que faz a mesma coisa que runQM, mas em vez disso considera os problemas de norma mínima e os métodos que usamos para resolver
function runNM(vec_matrizes,b_vec,x_vec)
    result_normx=[]  #Lista para armazenar as matrizes de norma de resíduo
    result_tempo=[]  #Lista para armazenar as matrizes de tempo
    result_erro=[] #Lista para armazenar os erros relativos
    for i in eachindex(vec_matrizes)  #Iterando pelo vetor externo
        result_x=zeros(length(vec_matrizes[i]), 3)  #Matriz para ||x||
        result_t=zeros(length(vec_matrizes[i]), 3)  #Matriz para tempo
        result_er=zeros(length(vec_matrizes[i]), 3) #Matriz para o erro relativo
        for j in eachindex(vec_matrizes[i])  #Iterando pelas matrizes internas
            m=size(vec_matrizes[i][j],1)  #Número de linhas
            b=b_vec[i][j] #Vetor b do sistema
            x=x_vec[i][j]  #Solução exata
            norma = zeros(2); t=zeros(2); erro=zeros(2)  #Vetor para norma da solução, tempo e erro relativo
            for k in 1:2  #Iterando para cada método em estudo e guardando tempo/norma
                t[k] = @elapsed x_resp=normaMin(vec_matrizes[i][j],b,k)
                norma[k]=norm(x_resp); erro[k]=norm(x_resp-x)/norm(x)
            end
            #Preenchendo
            result_x[j, 1]=m; result_t[j, 1]=m; result_er[j,1]=m
            result_er[j, 2:end]=erro #Armazenando os erros relativos
            result_x[j, 2:end]=norma  #Armazenando os valores de ||Ax-b||
            result_t[j, 2:end]=t  #Armazenando os valores de tempo
        end
        push!(result_normx, result_x)  #Adicionando a matriz de ||Ax-b|| à lista
        push!(result_erro, result_er) #Adicionando a matriz dos erros relativos à lista
        push!(result_tempo, result_t)  #Adicionando a matriz de tempo à lista
    end
    return result_normx, result_erro, result_tempo # Retornando as listas de matrizes
end