import SwiftUI
import DSWaveformImage

@available(iOS 15.0, macOS 12.0, *)
public struct WaveformLiveCanvas: View {
    public static let defaultConfiguration = Waveform.Configuration(damping: .init(percentage: 0.125, sides: .both))

    public let samples: [Float]
    public let configuration: Waveform.Configuration
    public let renderer: WaveformRenderer
    public let shouldDrawSilencePadding: Bool

    @StateObject private var waveformDrawer = WaveformImageDrawer()

    public init(
        samples: [Float],
        configuration: Waveform.Configuration = defaultConfiguration,
        renderer: WaveformRenderer = LinearWaveformRenderer(),
        shouldDrawSilencePadding: Bool = false
    ) {
        self.samples = samples
        self.configuration = configuration
        self.renderer = renderer
        self.shouldDrawSilencePadding = shouldDrawSilencePadding
    }

    public var body: some View {
        Canvas(rendersAsynchronously: true) { context, size in
            context.withCGContext { cgContext in
                waveformDrawer.draw(waveform: samples, on: cgContext, with: configuration.with(size: size), renderer: renderer)
            }
        }
        .onAppear {
            waveformDrawer.shouldDrawSilencePadding = shouldDrawSilencePadding
        }
        .onChange(of: shouldDrawSilencePadding) { newValue in
            waveformDrawer.shouldDrawSilencePadding = newValue
        }
    }
}
