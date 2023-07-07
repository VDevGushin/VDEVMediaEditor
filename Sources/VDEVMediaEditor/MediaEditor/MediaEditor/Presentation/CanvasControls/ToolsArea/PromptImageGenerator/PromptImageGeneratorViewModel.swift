//
//  PromptImageGeneratorViewModel.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import Combine
import UIKit

final class PromptImageGeneratorViewModel: ObservableObject {
    @Published private(set) var state: VMState = .notStarted
    @Published private(set) var progressImage: UIImage? = nil
    @Published var messageToSubmit: String = ""
    @Published var canSubmit: Bool = false
    private var operation: AnyCancellable?
    private var checkMessageOp: AnyCancellable?
    private let generateImageFromTextService = GenerateImageFromTextService()
    private let onComplete: (UIImage) -> Void
    
    init(onComplete: @escaping (UIImage) -> Void) {
        self.onComplete = onComplete
    
        checkMessageOp = $messageToSubmit.map {
            let message = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            return message.isEmpty
        }
        .sink(on: .main, object: self) { wSelf, value in
            wSelf.canSubmit = !value
        }
        
        operation = generateImageFromTextService.state
            .sink(on: .main, object: self) { wSelf, value in
                switch value {
                case .inaccessible:
                    wSelf.state = .inaccessible
                case.loading:
                    wSelf.state = .loading
                    wSelf.progressImage = nil
                case .notStarted:
                    wSelf.state = .notStarted
                    wSelf.progressImage = nil
                case .success(image: let image):
                    wSelf.onComplete(image)
                    wSelf.progressImage = nil
                case .error(error: let error):
                    wSelf.state = .error(error: error)
                    wSelf.progressImage = nil
                case .inProgress(progress: let progress,
                                 progressImageUrl: let progressImageUrl):
                    wSelf.state = .inProgress(progress: progress)
                    wSelf.getProgressImage(from: progressImageUrl)
                }
            }
    }
    
    private func getProgressImage(from url: URL?) {
        Task {
            guard let url = url else { return }
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                return
            }
            await MainActor.run { [weak self] in
                self?.progressImage = image
            }
        }
    }
    
    func submit(message: String) {
        let message = message.trimmingCharacters(in: .whitespacesAndNewlines)
        generateImageFromTextService.execute(message: message)
    }
    
    func cancelLoadCoreML() {
        generateImageFromTextService.cancel()
    }
    
    func onErrorConfirm() {
        generateImageFromTextService.removeMessageID()
    }
    
    func randomMessage() {
        let index = Int.random(in: 0...rundomMessages.count-1)
        self.messageToSubmit = rundomMessages[index]
    }
}

extension PromptImageGeneratorViewModel {
    enum VMState {
        case loading
        case notStarted
        case inaccessible
        case error(error: Error? = nil)
        case inProgress(progress: Int)
    }
}

private let rundomMessages: [String] = [
         """
         man in a ruin of an ancient city invaded by the jungle, light, unreal engine 5 and Octane Render,highly detailed, photorealistic, cinematic
         """,
         """
        a little girl with light brown short wavy curly hair and blue eyes floating in space, gazing in wonder at a quasar, Clear, detailed face. Clean Cel shaded vector art by lois van baarle, artgerm, Helen huang, by makoto shinkai and ilya kuvshinov, rossdraws, illustration
        """,
         """
sci-fi cosmic diarama of a quasar and jellyfish in a resin cube, volumetric lighting, high resolution, hdr, sharpen, Photorealism
""",
"""
maze, Narrow steep staircase, Old Building, Floating buildings, Urban, City rain, art by miyazaki and Ian McQue and Akihiko Yoshida and Katsuya Terada, colorful, trending on artstation, gorgeous, ultra-detailed, realistic, 8k, octane render, hyper detailed, cinematic
""",
     """
     Extreme close up of an eye that is the mirror of the nostalgic moments, nostalgia expression, sad emotion, tears, made with imagination, detailed, photography, 8k, printed on Moab Entrada Bright White Rag 300gsm, Leica M6 TTL, Leica 75mm 2.0 Summicron-M ASPH, Cinestill 800T
     """,
              """
              a moody foggy environment inside a curvilinear space looking up at a tall open oculus with light filtering down, back-lit uplit, unreal engine
              """,
         """
curved building facade made from transparent smooth and endless fluidity style parametric future architecture, concept art, highly detailed, beautiful scenery, cinematic, beautiful light, hyperreal, octane render, hdr, long exposure, 8K, realistic, fog, moody, gopro
""",
         """
Spectacular Tiny World in the Transparent Jar On the Table, interior of the Great Hall, Elaborate, Carved Architecture, Anatomy, Symetrical, Geometric and Parameteric Details, Precision Flat line Details, Pattern, Dark fantasy, Dark errie mood and ineffably mysterious mood, Technical design, Intricate Ultra Detail, Ornate Detail, Stylized and Futuristic and Biomorphic Details, Architectural Concept, Low contrast Details, Cinematic Lighting, 8k, by moebius, Fullshot, Epic, Fullshot, Octane render, Unreal ,Photorealistic, Hyperrealism
""",
                  """
         The parametric hotel lobby is a sleek and modern space with plenty of natural light. The lobby is spacious and open with a variety of seating options. The front desk is a sleek white counter with a parametric design. The walls are a light blue color with parametric patterns. The floor is a light wood color with a parametric design. There are plenty of plants and flowers throughout the space. The overall effect is a calm and relaxing space. occlusion, moody, sunset, concept art, octane rendering, 8k, highly detailed, concept art, highly detailed, beautiful scenery, cinematic, beautiful light, hyperreal, octane render, hdr, long exposure, 8K, realistic, fog, moody, fire and explosions, smoke, 50mm f2.8
         """,
         """
Hyper real glass flowers, blue organic twisting. octane render, unreal engine, blender render, immersive detail, enhanced quality
""",
         """
an artist desk full of drawings from the hobbit – colourful – paint spilled – brushes, pencils – high quality – 16k resolution
"""
]


