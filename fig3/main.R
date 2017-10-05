rm( list=ls() )
load( 'Rdata/pars.Rdata' )
source( 'mainfxn.R' )
source( 'simfxn.R' )
source( '../code/make_peer.R' )
source( '../code/make_sva.R' )
source( '../code/make_iasva.R' )
source( '../code/make_smartsva.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )
for( type in sample( types ) )
	for( meta in sample(2) )
		for( fac in sample( factypes ) )
{

	if( fac == 'ice' ) next

	if( file.exists(	paste0( 'Rdata/', fac, '_', meta, '_', type, '_', it, '_', max(Ks), '.Rdata' ) ) ) next
	sink(							paste0( 'Rout/'	, fac, '_', meta, '_', type, '_', it, '.Rout' ) )

	simdat	<- sim_fxn( seed=it, sig2_g=sig2_gs[type], ncaus=ncauss[type] )
	caus_p	<- simdat$caus_p
	Y				<- simdat$Y
	g				<- simdat$g
	rm( simdat )

	for( K in Ks )
		tryCatch(
	{
		time	<- system.time({
			Z	<- mainfxn( fac, meta, g, K )
		})[3]
		cat( 'mainfxn time=', time, '\n' )
		save( Y, Z, g, time, caus_p, file=paste0( 'Rdata/', fac, '_', meta, '_', type, '_', it, '_', K, '.Rdata' ) )
		rm( Z )
	}, error=function(e){
		print( c( type, meta, fac ) )
		print( e )
	})
	sink()

}
