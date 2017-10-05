rm( list=ls() )
load( file='../geuvadis/processed_data/Y_final.Rdata' )
rm(Y)

# simulation pars
maxit		<- 1e4

### SNP effect
a.n	<- 4
as	<- c( 0, .3, .6, .9 )

### number fitted confounders=max number corrected confounders
Ks	<- c( 1, 5, 10, 20, 40 )
K.n	<- length(Ks)

factypes	<- c( 'pc', 'peer', 'sva' )
fac.n			<- length( factypes )

save.image( file='Rdata/pars.Rdata' )
