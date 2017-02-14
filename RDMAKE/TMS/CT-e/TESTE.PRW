
nPosFrete	:= aScan( aResult , { |Z| 'FRETE' == AllTrim(Z[1]) } )
nPosMargem	:= aScan( aResult , { |Z| 'MARGEM' $ Z[1] } )

aResult[nPosFrete][2] := cValToChar( Val(aResult[nPosFrete][2]) + Val(aResult[nPosMargem][2]) )

aDel( aResult, nPosMargem )
aSize( aResult, Len(aResult) - 1 )

