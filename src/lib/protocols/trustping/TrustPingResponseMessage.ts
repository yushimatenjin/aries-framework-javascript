import { Equals, IsString } from 'class-validator';

import { AgentMessage } from '../../agent/AgentMessage';
import { MessageType } from './messages';
import { TimingDecorator } from '../../decorators/timing/TimingDecorator';

export interface TrustPingResponseMessageOptions {
  comment?: string;
  id?: string;
  threadId: string;
  timing?: Pick<TimingDecorator, 'inTime' | 'outTime'>;
}

/**
 * Message to respond to a trust ping message
 *
 * @see https://github.com/hyperledger/aries-rfcs/blob/master/features/0048-trust-ping/README.md#messages
 */
export class TrustPingResponseMessage extends AgentMessage {
  /**
   * Create new TrustPingResponseMessage instance.
   * responseRequested will be true if not passed
   * @param options
   */
  constructor(options: TrustPingResponseMessageOptions) {
    super();

    if (options) {
      this.id = options.id || this.generateId();
      this.comment = options.comment;

      this.setThread({
        threadId: options.threadId,
      });

      if (options.timing) {
        this.setTiming({
          inTime: options.timing.inTime,
          outTime: options.timing.outTime,
        });
      }
    }
  }

  @Equals(TrustPingResponseMessage.type)
  static readonly type = MessageType.TrustPingResponseMessage;
  readonly type = TrustPingResponseMessage.type;

  @IsString()
  comment?: string;
}
