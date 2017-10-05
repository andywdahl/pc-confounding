rm( list=ls() )
load( file='../geuvadis/processed_data/Y_final.Rdata' )
rm(Y)

fs			<- c( .1		, .1		, .1		, .9				  )
sig2_xs	<- c( .01		, .1		, .1		,	.1				  )
sig2_us	<- c( .1		, .1		, .4		,	.1				  )
types		<- c( 'base', 'hix1', 'hiu'	, 'dense,hix' )

rho2s			<- seq( 0, .9, len=8 )

names( fs				)	<- types
names( sig2_xs	)	<- types
names( sig2_us	)	<- types
type.n	<- length(types)

dat_types	<- c( 'real', 'white', 'whitex2' )

factypes<- c( 'pca', 'peer', 'sva', 'smartsva', 'dummy', 'suporacle', 'ice' )
fac.n		<- length( factypes )
r.n			<- length( rho2s )
dat.n		<- length( dat_types )

cols				<- c( 2:5, 1, 6, 'orange' )
names(cols)	<- factypes

tols	<- c( .01, .001, .05 )

save.image( file='Rdata/pars.Rdata' )
