include("Tests.jl")
include("Matrices.jl")
using Suppressor, DataFrames, PrettyTables, Printf

#Função para montar as tabelas e colocar em um arquivo de texto
#Assumindo vec_matrizes contendo apenas matrizes em pé (m>n)
function tables(vec_matrizes,bQM,bNM,xNM,tituloQM="OutputQM.txt",tituloNM="OutputNM.txt")
    #Obtendo os resultados -> Matriz já tem a primeira coluna com os n's que variam por conveniencia 
    resultQMres,resultQMtempo=runQM(vec_matrizes,bQM)
    resultNMnorm,resultNMerro,resultNMtempo=runNM(transposeAll(vec_matrizes),bNM,xNM)

    #Passando os dados do problema de quadrados mínimos para DataFrame
    header=["n", "Direto", "Cholesky", "QR"]
    resultQMres=[DataFrame(resultQMres[i], header) for i in eachindex(resultQMres)]
    resultQMtempo=[DataFrame(resultQMtempo[i], header) for i in eachindex(resultQMtempo)]

    #Passando os dos problemas de norma mínima
    header=["m", "Sela", "QR"]
    resultNMnorm=[DataFrame(resultNMnorm[i], header) for i in eachindex(resultNMnorm)]
    resultNMerro=[DataFrame(resultNMerro[i], header) for i in eachindex(resultNMerro)]
    resultNMtempo=[DataFrame(resultNMtempo[i], header) for i in eachindex(resultNMtempo)]

    #Tratativa dos dados
    #No problema de quad.min
    for i in eachindex(resultQMres)
        #Passando N para inteiro no prob. de quad min
        resultQMres[i].n=Int.(resultQMres[i].n)
        resultQMtempo[i].n=Int.(resultQMtempo[i].n);  
        #Demais entradas em notação científica
        for col in names(resultQMres[i])[2:end]
            resultQMres[i][!, col]=string.(@sprintf("%.3e", x) for x in resultQMres[i][!,col])
            resultQMtempo[i][!, col]=string.(@sprintf("%.3e", x) for x in resultQMtempo[i][!,col])
        end
    end

    #Para o prob. de norma min.
    for i in eachindex(resultNMnorm)
        #Passando m para inteiro
        resultNMnorm[i].m=Int.(resultNMnorm[i].m)  
        resultNMerro[i].m=Int.(resultNMerro[i].m)
        resultNMtempo[i].m=Int.(resultNMtempo[i].m) 
        #Demais entradas em notação científica
        for col in names(resultNMnorm[i])[2:end]
            resultNMnorm[i][!, col]=string.(@sprintf("%.3e", x) for x in resultNMnorm[i][!,col])
            resultNMerro[i][!, col]=string.(@sprintf("%.3e", x) for x in resultNMerro[i][!,col])
            resultNMtempo[i][!, col]=string.(@sprintf("%.3e", x) for x in resultNMtempo[i][!,col])
        end
    end
    
    #Coletando o número de m's usados
    m=length(vec_matrizes)

    #Printando e colocando em arquivos de texto
    open(tituloQM,"w") do io
        for i=1:m
            #Para o problema de quadrados mínimos
            #Cabeçalho
            write(io,"Quad. min - Norma do resíduo - m="*string(size(vec_matrizes[i][1],1)))
            write(io,'\n')
            #Contéudo
            latex_tab=@capture_out pretty_table(resultQMres[i],backend=Val(:latex),header=names(resultQMres[i]))
            write(io,latex_tab); write(io,'\n')
            
            #Cabeçalho
            write(io,"Quad. min. - Tempo de execução - m="*string(size(vec_matrizes[i][1],1)))
            write(io,'\n')
            #Conteúdo
            latex_tab=@capture_out pretty_table(resultQMtempo[i],backend=Val(:latex),header=names(resultQMtempo[i]))
            write(io,latex_tab); write(io,'\n')
        end
    end

    open(tituloNM,"w") do io
        for i=1:m
            #Para o problema de norma mínima
            #Cabeçalho
            write(io,"Norma min. - Norma de x - n="*string(size(vec_matrizes[i][1],1)))
            write(io,'\n')
            #Contéudo
            latex_tab=@capture_out pretty_table(resultNMnorm[i],backend=Val(:latex),header=names(resultNMnorm[i]))
            write(io,latex_tab); write(io,'\n')
            
            #Cabeçalho
            write(io,"Norma min. - Erro relativo - n="*string(size(vec_matrizes[i][1],1)))
            write(io,'\n')
            #Contéudo
            latex_tab=@capture_out pretty_table(resultNMerro[i],backend=Val(:latex),header=names(resultNMerro[i]))
            write(io,latex_tab); write(io,'\n')

            #Cabeçalho
            write(io,"Norma min. - Tempo- n="*string(size(vec_matrizes[i][1],1)))
            write(io,'\n')
            #Contéudo
            latex_tab=@capture_out pretty_table(resultNMtempo[i],backend=Val(:latex),header=names(resultNMtempo[i]))
            write(io,latex_tab); write(io,'\n')
        end
    end    
end

#Função para rodar o caso normal e o caso perturbado e salvar tudo
function runTest(mVec)
    #Gerando as matrizes de teste
    vec,vec_perturb=testMatrices(mVec)

    #Os vetores de teste
    bQM=testb(mVec)
    bNM,xNM=testbNM(transposeAll(vec))

    #Executando
    tables(vec, bQM, bNM, xNM, "OutputQM_normal.txt", "OutputNM_normal.txt")
    tables(vec_perturb, bQM, bNM, xNM, "OutputQM_perturb.txt", "OutputNM_perturb.txt")
end

mVec=[10,100,1000]