import { createLibp2p } from 'libp2p';
import { tcp } from '@libp2p/tcp';
import { noise } from '@chainsafe/libp2p-noise';
import { mplex } from '@libp2p/mplex';
import { gossipsub } from '@libp2p/gossipsub';
import { identify } from '@libp2p/identify';
import { multiaddr } from '@multiformats/multiaddr';

export async function createNode(bootstrapMultiaddrs) {
  const node = await createLibp2p({
    addresses: {
      listen: ['/ip4/0.0.0.0/tcp/0']
    },
    transports: [tcp()],
    connectionEncryption: [noise()],
    streamMuxers: [mplex()],
    services: {
      identify: identify(),
      pubsub: gossipsub({ allowPublishToZeroPeers: true })
    }
  });

  node.addEventListener('peer:connect', (evt) => console.log(`🤝 Peer Connected: ${evt.detail.toString()}`));
  node.services.pubsub.addEventListener('peer:subscribe', (evt) => console.log(`🔔 Peer ${evt.detail.peerId.toString()} subscribed to ${evt.detail.topic}`));

  console.log('libp2p node started with Peer ID:', node.peerId.toString());
  node.getMultiaddrs().forEach((addr) => console.log('Listening on:', addr.toString()));

  if (bootstrapMultiaddrs) {
    for (const addr of bootstrapMultiaddrs) {
      console.log(`Dialing bootstrap peer at ${addr}`);
      await node.dial(multiaddr(addr));
    }
  }

  return node;
}