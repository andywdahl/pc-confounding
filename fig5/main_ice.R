rm( list=ls() )
load( file='Rdata/pars.Rdata' )
source( 'simfxn.R' )
source( '../code/ice_fxn_new.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )
fac <- 'ice'
for( type in sample( types ) )
	for( meta in 1:2 )
		for( splitid in 1:2 )
			for( dat_type in dat_types[1] )
				for( u.i in 1:u.n )
{
	savefile	<-	paste0( 'Rdata/', fac, '_', meta, '_', type, '_',splitid, '_',dat_type, '_',u.i, '_', it, '.Rdata' )
	if( file.exists( savefile ) ) next
	sink(					paste0( 'Rout/'	, fac, '_', meta, '_', type, '_',splitid, '_',dat_type, '_',u.i, '_', it, '.Rout' ) )
	tryCatch({

		simdat	<- sim_fxn( seed=it, sig2_x=sig2_xs[type], sig2_u=sig2_us[u.i], rho=sqrt(rho2s[type]), f=fs[type], dat_type=dat_type )
		caus_p	<- simdat$caus
		if( splitid == 1 ){
			sub	<- simdat$is
		} else {
			sub	<- (1:simdat$N)[-simdat$is]
		}
		Y				<- simdat$Y [sub,]
		g				<- simdat$g [sub]
		rm( simdat )

		time	<- system.time({
			out	<- ice_summ_fxn( Y, g, ML=(meta==1) )
		})[3]
		cat( 'maintime=', time, '\n' )

		save( out, caus_p, file=savefile )

		rm( Y, g, time, caus_p, out )

	}, error=function(e){ print( e ); print( c( type, meta, fac ) ) })
	sink()
}
