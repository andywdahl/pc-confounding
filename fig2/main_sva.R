rm( list=ls() )
load( file='Rdata/pars.Rdata' )

source( '../code/simfxn.R' )
source( '../code/run_one_sim.R' )
source( '../code/make_sva.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )

blank_out	<- array( NA,
	dim=c(					3,											K.n,	P ),
	dimnames=list(	c('beta','sd','pval'),	Ks,		1:P )
)
for( a in sample(a.n) ){

	savefile	<- paste0( 'Rdata/sva_', a, '_', it, '.Rdata' )
	if( file.exists( savefile ) )
		next

	Y	<- matrix( rnorm( N*P ), N, P )
	simdat	<- sim_fxn( Y, seed=it, h2_g=as[a], gauss=TRUE, ncaus=1 )
	rm( Y )
	caus_p	<- simdat$caus_p

	time_1	<- system.time( SVs		<- make_sva( simdat$Y, K=max(Ks)							) )[3]
	time_2	<- system.time( SVs2	<- make_sva( simdat$Y, K=max(Ks), X=simdat$g	) )[3]

	time_3	<- system.time({
		if( length( SVs ) == 1 & all(is.na( SVs )) ){
			out			<-  blank_out
		} else {
			out			<- run_one_sim( simdat$Y, simdat$g, Ks, Z=SVs )
		}
		if( length( SVs2 ) == 1 & all(is.na( SVs2 )) ){
			out			<-  blank_out
		} else {
			out_2		<- run_one_sim( simdat$Y, simdat$g, Ks, Z=SVs2 )
		}
	})[3]

	save( time_1, time_2, time_3, caus_p, out, out_2, file=savefile )

}
