rm( list=ls() )
load( file='../geuvadis/processed_data/Y_final.Rdata' )
rm(Y)

ncauss	<- c( round(P/10)	, round( P*19/20 ), round(P/10)	)
sig2_gs	<- c( .01					,	.01							, .25					)
types		<- c( 'base'			, 'densest'				, 'higher'		)

names( ncauss )	<- 
names( sig2_gs ) <- types

Ks				<- c( 1, 2, 5, 10, 20 )

factypes	<- c( 'pca', 'peer', 'sva', 'smartsva', 'oracle', 'iasva', 'ice' )
cols			<- c( 2:6, 'brown', 'orange' )
names(cols)	<- factypes

type.n	<- length( types )
K.n			<- length( Ks )
fac.n		<- length( factypes )

tols	<- c( .01, .001, .0001 )
save.image( file='Rdata/pars.Rdata' )
