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
    header=["n", "Sela", "QR"]
    resultNMnorm=[DataFrame(resultNMnorm[i], header) for i in eachindex(resultNMnorm)]
    resultNMerro=[DataFrame(resultNMerro[i], header) for i in eachindex(resultNMerro)]
    resultQMtempo=[DataFrame(resultNMtempo[i], header) for i in eachindex(resultNMtempo)]

    return resultQMres
end