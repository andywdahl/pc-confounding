rm( list=ls() )
load( file='../geuvadis/processed_data/Y_final.Rdata' )
rm(Y)

fs			<- c( .1		, .1		, .1			, .9				 , .9			)
sig2_xs	<- c( .01		, .1		, .1			,	.1				 , .01		)
rho2s		<- c( .25		, .25		, 0				,	.25				 , .25		)
types		<- c( 'base', 'hix'	,'hix,lro', 'dense,hix', 'dense')

names( sig2_xs	)	<- types
names( rho2s		)	<- types
names( fs				)	<- types
type.n	<- length(types)

sig2_us	<- seq( 0, .9, len=8 )

dat_types	<- c( 'real', 'white', 'whitex2' )

factypes<- c( 'pca', 'peer', 'sva', 'smartsva', 'dummy', 'oracle', 'ice' )
fac.n		<- length( factypes )
u.n			<- length( sig2_us )
dat.n		<- length( dat_types )

tols	<- c( .01, .001, .05 )

save.image( file='Rdata/pars.Rdata' )
