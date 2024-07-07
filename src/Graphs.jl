include("Tests.jl")
using Suppressor, DataFrames, PrettyTables, Printf

#Função para montar as tabelas e colocar em um arquivo de texto
#Assumindo vec_matrizes contendo apenas matrizes em pé (m>n)
function tables(vec_matrizes)
    #Obtendo os resultados -> Matriz já tem a primeira coluna com os n's que variam por conveniencia 
    resultQMres,resultQMtempo=runQM(vec_matrizes)
    resultNMnorm, resultNMerro, resultNMtempo=runNM(transposeAll(vec_matrizes))

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
    return resultNMnorm, resultNMerro, resultNMtempo
end